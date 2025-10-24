import * as fs from 'fs';
import * as path from 'path';

function checkDuplicatesInCsv(): void {
  const csvPath = path.join(__dirname, 'data', 'season_1_allowlist.csv');
  
  try {
    // Read the CSV file
    const csvContent = fs.readFileSync(csvPath, 'utf-8');
    const lines = csvContent.trim().split('\n');
    
    // Skip the header row
    const dataLines = lines.slice(1);
    
    // Extract wallet addresses (first column)
    const walletAddresses: string[] = [];
    const seenAddresses = new Set<string>();
    const duplicates = new Set<string>();
    
    for (const line of dataLines) {
      if (line.trim() === '') continue; // Skip empty lines
      
      const columns = line.split(',');
      if (columns.length > 0) {
        const walletAddress = columns[0].trim().toLowerCase();
        
        walletAddresses.push(walletAddress);
        
        if (seenAddresses.has(walletAddress)) {
          duplicates.add(walletAddress);
        } else {
          seenAddresses.add(walletAddress);
        }
      }
    }
    
    console.log(`Total entries (excluding header): ${walletAddresses.length}`);
    console.log(`Unique addresses: ${seenAddresses.size}`);
    console.log(`Duplicated addresses: ${duplicates.size}`);
    
    if (duplicates.size > 0) {
      console.log('\nDuplicated wallet addresses:');
      duplicates.forEach(address => {
        const count = walletAddresses.filter(addr => addr === address).length;
        console.log(`  ${address} (appears ${count} times)`);
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