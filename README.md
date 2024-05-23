DIGITAL FORENSICS ANALYZER PROJECT- AMIT PERSKY

This project involved the creation of a comprehensive program for digital forensic analysis. Focused on automated hard disk drive (HDD) and memory investigations, it was designed to identify, extract, and display crucial data elements like network traffic or human-readable information. Additionally, the program integrates with the Volatility software for in-depth memory analysis and outputs detailed reports. It also features a dedicated function to install necessary forensic tools, ensuring smooth operation.


In the Digital forensics analyzer Project.pdf, you can see how the script is working and behaving.

Here are the instructions for using the Memory Analysis Tool, which will be placed on GitHub for users to understand how to use it. The tool leverages a shell script to automate memory analysis using Volatility and other forensic tools.

## Memory Analysis Tool Instructions

### Overview
This project provides a comprehensive tool for memory analysis using a cyber forensic approach. The tool automates the process of analyzing a memory dump file (with a `.mem` extension) and integrates with Volatility for in-depth memory analysis. The results are saved in a specified directory, and the process can be customized by modifying certain variables in the script.

### Requirements
1. Linux operating system (preferably Kali Linux).
2. Root privileges.
3. Necessary forensic tools installed (`figlet`, `bulk-extractor`, `binwalk`, `foremost`, `exiftool`, `binutils`).
4. Volatility installed in the same directory as the script.
5. Memory dump file (`.mem` extension).

### Setup
1. Place the memory dump file (with `.mem` extension) into the `Memorytool` folder.
2. Download or clone this repository to your local machine.
3. Ensure that the script `Digitalforensicsproject.sh` is executable. You can set the executable permission by running:
   ```bash
   chmod +x Digitalforensicsproject.sh
   ```

### Running the Tool
1. **Navigate to the directory:**
   ```bash
   cd /path/to/Memorytool
   ```
   
2. **Run the script:**
   ```bash
   sudo ./Digitalforensicsproject.sh
   ```
   Ensure you have root privileges, as the tool checks and exits if not run as root.

### Script Details
1. **Root Check:**
   - The script starts by verifying if the user has root permissions. If not, it exits.

2. **File Selection:**
   - The user is prompted to enter the filename for analysis. The script checks for the file's existence in the current directory.

3. **Tool Installation:**
   - The script installs necessary forensic tools if they are not already installed.

4. **Data Extraction:**
   - The script provides options to use different carvers (`exiftool`, `foremost`, `binwalk`, `bulk_extractor`, `strings`) to extract data from the memory dump file.
   - The results are saved in an `Output` directory on the desktop.

5. **Network Traffic Analysis:**
   - The script attempts to find network traffic files and displays their locations and sizes.

6. **Human-Readable Strings Extraction:**
   - The script allows the user to search for specific strings within the files and outputs any matches.

7. **Memory Analysis with Volatility:**
   - The script checks if the file can be analyzed using Volatility.
   - It identifies the memory profile and displays running processes, network connections, and registry information.

8. **Results Compilation:**
   - The script displays general statistics about the analysis, including the time taken and the number of files found.
   - All results are saved in a report and zipped into `Your_Results.zip` on the desktop.

### Customization
- Users may need to modify the `HOME` variable and other paths within the script to match their environment.
- The script is designed to be flexible and can be adjusted according to specific needs or configurations.

### Conclusion
This tool simplifies the process of memory analysis by automating the extraction and analysis of data from memory dump files. Users can customize the script to fit their environment and requirements, making it a versatile tool for digital forensic investigations.

By following these instructions, users can effectively utilize the Memory Analysis Tool for their forensic analysis needs.

