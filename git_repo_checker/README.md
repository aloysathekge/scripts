# Git Repository Checker

A PowerShell script that helps you manage and audit multiple Git repositories, particularly useful when dealing with different Git configurations for work and personal accounts.

## Features

- Scans a directory recursively for Git repositories
- Displays current remote URLs for each repository
- Shows current Git configuration (user email and name)
- Allows batch checking of Git configurations
- Provides option to update repository configurations:
  - Switch between work and personal accounts
  - Update remote URLs
  - Update Git user email and name
- Supports configuration file for easy customization
- Remembers default repository path
- Validates Git installation and repository paths
- Provides detailed error handling and feedback

## Prerequisites

- Windows operating system
- Git installed and accessible from PowerShell
- PowerShell 5.1 or higher

## Installation

1. Clone or download this repository
2. Place the following files in your desired location:
   - `repositories-check.ps1`
   - `config.json`

## Configuration

The script uses a `config.json` file for settings. You can customize it.


## Usage

1. Open PowerShell
2. Navigate to the script's directory
3. Run the script:

4. When prompted:
   - Press Enter to use the default path (if configured)
   - Or enter a new path to scan for repositories
5. The script will:
   - Verify Git installation
   - Load configuration settings
   - Find all Git repositories in the specified directory
   - For each repository:
     - Display current remote URLs
     - Show current Git configuration
     - Offer option to update settings


## Error Handling

The script includes comprehensive error handling for:
- Missing Git installation
- Invalid repository paths
- Configuration file issues
- Git command failures
- Repository access problems

## Customization

You can customize the script by:
1. Editing the `config.json` file to set your:
   - Work and personal email addresses
   - Git usernames
   - SSH configurations
   - Git host settings
   - Default repository path
2. The configuration file is automatically created with default values if it doesn't exist

## Contributing

Feel free to submit issues and enhancement requests! Some areas for potential improvement:
- Additional Git host support
- Batch update operations
- Custom SSH key management
- Repository status checking
- Backup functionality

## License

This project is open source and available for all,  git clone and use it
