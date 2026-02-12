// yarn check-duplicates

import * as fs from 'fs';
import * as path from 'path';

function checkDuplicatesInCsv(): void {
  const csvPath = path.join(__dirname, '..', 'data', 'season5', 'testlist.csv');

  try {
    // Read the CSV file
    const csvContent = fs.readFileSync(csvPath, 'utf-8');
    const lines = csvContent.trim().split('\n');

    // Skip the header row
    const dataLines = lines.slice(1);

    // Extract wallet addresses (first column)
    const walletAddresses: string[] = [];
    const seenAddresses = new Map<string, number[]>(); // address -> line numbers
    const duplicates = new Set<string>();

    for (let i = 0; i < dataLines.length; i++) {
      const line = dataLines[i];
      if (line.trim() === '') continue; // Skip empty lines

      const columns = line.split(',');
      if (columns.length > 0) {
        const walletAddress = columns[0].trim().toLowerCase();
        const lineNumber = i + 2; // +2 because we skipped header and arrays are 0-indexed

        walletAddresses.push(walletAddress);

        if (seenAddresses.has(walletAddress)) {
          duplicates.add(walletAddress);
          seenAddresses.get(walletAddress)!.push(lineNumber);
        } else {
          seenAddresses.set(walletAddress, [lineNumber]);
        }
      }
    }

    console.log(`Total entries (excluding header): ${walletAddresses.length}`);
    console.log(`Unique addresses: ${seenAddresses.size}`);
    console.log(`Duplicated addresses: ${duplicates.size}`);

    if (duplicates.size > 0) {
      console.log('\nDuplicated wallet addresses:');
      duplicates.forEach(address => {
        const lineNumbers = seenAddresses.get(address)!;
        console.log(`\n  ${address}`);
        console.log(`  Appears ${lineNumbers.length} times on lines: ${lineNumbers.join(', ')}`);
        
        // Show the actual line content for each occurrence
        lineNumbers.forEach(lineNum => {
          const actualLine = lines[lineNum - 1]; // -1 because lines array is 0-indexed
          console.log(`    Line ${lineNum}: ${actualLine}`);
        });
      });
    } else {
      console.log('\nNo duplicate addresses found!');
    }

  } catch (error) {
    console.error('Error reading CSV file:', error);
  }
}

// Run the function
checkDuplicatesInCsv();