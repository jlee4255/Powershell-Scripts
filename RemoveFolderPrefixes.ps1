# Remove "[*]" prefixes of downloaded folders name
# Define the directory path where the folders are located
$directoryPath = "\\TUF-AX3000-E438\Seagate\Downloads"

# Get all folders in the specified directory
try {
    $folders = Get-ChildItem -Path $directoryPath -Directory
} catch {
    Write-Host "Error accessing directory: $_"
    exit
}

foreach ($folder in $folders) {
    Write-Host "Processing folder: $($folder.FullName)"

    # Ensure the folder exists
    try {
        $item = Get-Item -LiteralPath $folder.FullName
    } catch {
        Write-Host "Folder does not exist or cannot be accessed: $($folder.FullName)"
        continue
    }

    $newFolderName = $folder.Name

    # Remove any prefix enclosed in square brackets
    $newFolderName = $newFolderName -replace '^\[[^\]]*\]\s*', ''

    # Only rename if the new folder name is different
    if ($newFolderName -ne $folder.Name) {
        try {
            # Define the new full path for the folder name
            $newFolderPath = Join-Path -Path $directoryPath -ChildPath $newFolderName
            
            # Log current and new folder paths for debugging
            Write-Host "Current folder path: $($folder.FullName)"
            Write-Host "New folder path: $newFolderPath"
            
            # Rename the folder
            Rename-Item -LiteralPath $folder.FullName -NewName $newFolderName -Force

            # Verify if the move was successful
            if (Test-Path -Path $newFolderPath) {
                Write-Host "Successfully renamed folder '$($folder.Name)' to '$newFolderName'"
            } else {
                Write-Host "Failed to rename folder '$($folder.Name)' to '$newFolderName'"
            }
        } catch {
            Write-Host "Error renaming folder '$($folder.Name)' to '$newFolderName': $_"
        }
    }
}

Write-Host "Folder renaming completed."
