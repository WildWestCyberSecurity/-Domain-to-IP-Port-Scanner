# 🔗 Domain-to-IP Port Scanner

🚀 A bash script that automates 🌐 domain-to-IP resolution, ⚡️ lightning-fast port scanning with Masscan, and 🛡️ in-depth analysis with RustScan. Ideal for comprehensive 🕵️‍♂️ network security evaluations!

## 📝 Table of Contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Output](#output)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

- 🌐 **Domain-to-IP Resolution**: Automatically resolves domain names to their corresponding IP addresses.
- ⚡️ **Masscan Integration**: Leverages Masscan to scan a wide range of ports quickly.
- 🛡️ **RustScan Detailed Analysis**: Performs detailed scanning on open ports identified by Masscan using RustScan.
- 📂 **Organized Output**: Outputs results in a well-structured format for easy analysis.

## 💻 Requirements

Make sure your system has the following tools installed:

- **bash**: Unix shell and command language.
- **curl**: Command-line tool for transferring data with URLs.
- **wget**: Network file downloader.
- **dig**: DNS lookup utility (usually part of `bind-utils` or `dnsutils` package).
- **RustScan**: High-speed port scanner with a focus on ease of use.
- **Masscan**: The fastest Internet port scanner.
- **xmllint**: XML parser and validator (`libxml2-utils` package).

## 📦 Installation

First, install the necessary tools:

```
sudo apt-get update
sudo apt-get install curl wget dnsutils libxml2-utils -y
```

The script will automatically install RustScan and Masscan if they are not already installed on your system.

## 🚀 Usage

To use the script, provide a file containing domain names and specify an output directory:

```
./port_scan.sh <domain_list_file> <output_directory>
```

### Example

```
./port_scan.sh domains.txt results/
```

- `<domain_list_file>`: Path to the file containing a list of domains (one per line).
- `<output_directory>`: Path to the directory where the output files will be saved.

## 📂 Output

The script generates the following output files in the specified directory:

- `ips.txt`: Contains the resolved IP addresses.
- `masscan_results.xml`: Masscan scan results in XML format.
- `ip_ports.txt`: IP addresses with their corresponding open ports.
- `*-rustscan.txt`: Detailed RustScan results for each IP and port.

## 🤝 Contributing

Contributions are welcome! If you have ideas for improvements or have found bugs, feel free to open an issue or submit a pull request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
###HACK THE PLANET NERDS!
