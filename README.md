# bb-dev

First attempt at a recon automation framework, bear with me...

## Tools

### ```.bb-dev_config```

Config file to store all configuration parameters and secrets for the framework. It is meant to be stored in the user's home folder and assigned 600 permissions.

### ```now.sh```

Bash script that prints the current timnestamp in the format ```+%y-%m-%d_%H_%M_%S_UTC```

Usage:
```Bash
Bash ./now.sh
```

### ```email.sh```

Bash utility script that sends emails. Subject and body are specified via command line arguments and the configuration parameters are read from ```.bb-dev_config```.

```Bash
Bash ./email.sh "Subject" "Absolute path to message body text file"
```

### ```runner.sh```

```runner.sh``` is being kept always running on the host in a "runner.sh" tmux session and is responsible for the persistence of the entire framework. ```runner.sh``` launches all workflows at different times/cadences, depending on the workflows.
At the current stage, ```runner.sh``` supports hourly and daily cadences.

### ```workflow1.sh```

This workflow is all about ```subfinder``` -> ```httpx``` -> ```nuclei``` 

```workflow1.sh``` is run by ```runner.sh``` at the top of every hour. It loops over programs/scopes files in the ```$home/inputs/``` folder, where all scope files have names starting with ```urls_*``` or ```_urls_*```. Files with name starting with ```urls_*``` are processed, while all programs scope files with name starting with ```_urls_*``` are ignored.

```workflow1.sh``` then processes all URLs/FQDNs in the scope files and runs each one of them thru the pipe ```subfinder``` -> ```httpx``` -> ```nuclei```. All results are saved in the ```$home/outputs/workflow1/``` folder in text files with names starting respectively with ```subfinder_urls_*```, ```httpx_urls_*``` and ```nuclei_urls_*```.

Required underlying tools:
* ```subfinder```
* ```httpx```
* ```nuclei```

```Bash
Bash code here
```

#### TODOs
  - Aaa
  - Aaa
  
### ```workflow2.sh```

This workflow is all about ```subfinder``` -> ```nmap```

```workflow2.sh``` is run by ```runner.sh``` every day at midnight. It loops over programs/scopes files in the ```$home/inputs/``` folder, where all scope files have names starting with ```urls_*``` or ```_urls_*```. Files with name starting with ```urls_*``` are processed, while all programs scope files with name starting with ```_urls_*``` are ignored.

```workflow2.sh``` then processes all URLs/FQDNs in the scope files and runs each one of them thru the pipe ```subfinder``` -> ```nmap```. All results are saved in the ```$home/outputs/workflow2/``` folder in text files with names starting respectively with ```subfinder_urls_*``` and ```nmap_urls_*```.

Required underlying tools:
* ```subfinder```
* ```nmap```

```Bash
Bash code here
```

#### TODOs
  - Aaa
  - Aaa

### ```workflow3.sh```

Bash script that...

```Bash
Bash code here
```
#### TODOs
  - Aaa
  - Aaa

## Licensing

The tool is licensed under the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Legal disclaimer

Usage of this tool to interact with targets without prior mutual consent is illegal. It's the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program. Only use for educational purposes.
