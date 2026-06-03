// yarn ts-node ./script/check-owners.ts
//
// Reads owner() of every Score Season NFT contract via `cast` and prints a
// table showing the current owner and whether the ownership transfer from the
// faulty deployer to the new address has been done.
//
// Requires:
//   - foundry's `cast` on PATH
//   - SONEIUM_RPC_URL set (loaded from .env)

import { execFileSync } from 'child_process';
import * as path from 'path';
import * as dotenv from 'dotenv';

dotenv.config({ path: path.join(__dirname, '..', '.env') });

// The owner address that was set by mistake (transfer NOT done).
const FAULTY_OWNER = '0xEE70e6d461F0888Fd9DB60cb5B2e933adF5f4c7C';
// The address ownership should be transferred to (transfer DONE).
const NEW_OWNER = '0xCc6b7dAa102d15110015825e5DFe89C13c447A19';

interface Contract {
  season: number | string;
  address: string;
}

const CONTRACTS: Contract[] = [
  { season: 'Aibo', address: '0x1e807EfC2416c6CD63cb3B01Dc91232D6F02d50A' },
  { season: 'checkIn', address: '0xaB948e5724E2c29a39E5897E3b7EDCAbebF5d196' },
  // Soneium Badge Collection — Ownable, not role-based.
  { season: 'Soneium Badge', address: '0x2A21B17E366836e5FFB19bd47edB03b4b551C89d' },
  { season: 1, address: '0x05AB5e724848cEFeac6D303CDf94032E5Cc3552B' },
  { season: 2, address: '0x6b2f6d8216e075d3a71f4aaf21d7158af9b8dc82' },
  { season: 3, address: '0x7BF02b42b9d4cCD85b497C9F53e6b7474f9c2546' },
  { season: 4, address: '0x17121f9a7041FFe3EF248F7b84658d9229bad64f' },
  { season: 5, address: '0xd8d14f829665183049707e0bdd93f9012bb3c4c2' },
  { season: 6, address: '0xe5a3d28fe65895d7cd7146fb50199b85fba74c3e' },
  { season: 7, address: '0x8F97Ff6a07F78Fb0259f543ed032A5985F2A92Ae' },
  { season: 8, address: '0x2E4A91B1a76D0Cbccc31526a1a6Cf81Dd9897E0c' },
  { season: 9, address: '0x822ce419cc3298e58B8D61e64981634bBC54338c' },
];

// Role-based contracts (AccessControl). The admin role checked is
// DEFAULT_ADMIN_ROLE == bytes32(0).
const DEFAULT_ADMIN_ROLE =
  '0x0000000000000000000000000000000000000000000000000000000000000000';

const ROLE_CONTRACTS: Contract[] = [
  { season: 'Yoki Legacy', address: '0x80E041b16a38f4caa1d0137565B37FD71b2f1E2b' },
];

function readOwner(rpcUrl: string, address: string): string {
  const out = execFileSync(
    'cast',
    ['call', address, 'owner()(address)', '--rpc-url', rpcUrl],
    { encoding: 'utf-8' }
  );
  return out.trim();
}

function hasRole(
  rpcUrl: string,
  address: string,
  role: string,
  account: string
): boolean {
  const out = execFileSync(
    'cast',
    [
      'call',
      address,
      'hasRole(bytes32,address)(bool)',
      role,
      account,
      '--rpc-url',
      rpcUrl,
    ],
    { encoding: 'utf-8' }
  );
  return out.trim() === 'true';
}

interface Row {
  season: number | string;
  address: string;
  owner: string;
  status: string;
}

function classify(owner: string): string {
  const o = owner.toLowerCase();
  if (o === NEW_OWNER.toLowerCase()) return '✅ transferred';
  if (o === FAULTY_OWNER.toLowerCase()) return '❌ faulty owner';
  return '❓ unknown owner';
}

function renderTable(headers: string[], data: string[][]): void {
  const widths = headers.map((h, i) =>
    Math.max(h.length, ...data.map((row) => row[i].length))
  );

  const fmt = (cols: string[]) =>
    '| ' + cols.map((c, i) => c.padEnd(widths[i])).join(' | ') + ' |';
  const sep = '|' + widths.map((w) => '-'.repeat(w + 2)).join('|') + '|';

  console.log(fmt(headers));
  console.log(sep);
  data.forEach((row) => console.log(fmt(row)));
}

function printTable(rows: Row[]): void {
  renderTable(
    ['Season', 'Contract', 'Owner', 'Status'],
    rows.map((r) => [String(r.season), r.address, r.owner, r.status])
  );
}

function main(): void {
  const rpcUrl = process.env.SONEIUM_RPC_URL;
  if (!rpcUrl) {
    console.error('Error: SONEIUM_RPC_URL is not set (check your .env).');
    process.exit(1);
  }

  const rows: Row[] = [];
  for (const c of CONTRACTS) {
    let owner: string;
    let status: string;
    try {
      owner = readOwner(rpcUrl, c.address);
      status = classify(owner);
    } catch (err) {
      owner = '<error>';
      status = `ERROR: ${(err as Error).message.split('\n')[0]}`;
    }
    rows.push({ season: c.season, address: c.address, owner, status });
  }

  console.log(`Compromised address: ${FAULTY_OWNER}`);
  console.log(`New address:         ${NEW_OWNER}\n`);

  printTable(rows);

  const notDone = rows.filter((r) => r.status.includes('faulty owner'));
  const errored = rows.filter((r) => r.status.startsWith('ERROR'));
  console.log(
    `\nSummary: ${rows.length - notDone.length - errored.length} done, ` +
      `${notDone.length} not done, ${errored.length} errored.`
  );
  if (notDone.length) {
    console.log(
      'Pending transfer for seasons: ' +
        notDone.map((r) => r.season).join(', ')
    );
  }

  // ---- Role-based contracts (AccessControl) ----
  const roleData: string[][] = [];
  for (const c of ROLE_CONTRACTS) {
    let faultyHas: string;
    let newHas: string;
    let status: string;
    try {
      const faulty = hasRole(rpcUrl, c.address, DEFAULT_ADMIN_ROLE, FAULTY_OWNER);
      const fresh = hasRole(rpcUrl, c.address, DEFAULT_ADMIN_ROLE, NEW_OWNER);
      faultyHas = faulty ? 'yes' : 'no';
      newHas = fresh ? 'yes' : 'no';
      // Good = compromised address has NO admin, new address HAS admin.
      status = !faulty && fresh ? '✅ ok' : '❌ check';
    } catch (err) {
      faultyHas = '<error>';
      newHas = '<error>';
      status = `ERROR: ${(err as Error).message.split('\n')[0]}`;
    }
    roleData.push([String(c.season), c.address, faultyHas, newHas, status]);
  }

  console.log('\nRole-based contracts (DEFAULT_ADMIN_ROLE):\n');
  renderTable(
    ['Name', 'Contract', 'Faulty has admin', 'New has admin', 'Status'],
    roleData
  );
}

main();
