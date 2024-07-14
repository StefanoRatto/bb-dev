# bb-dev

First attempt at a recon automation framework, bear with me...

## ```.bb-dev_config```

Config file to store all configuration parameters and secrets for the framework. It is meant to be stored in the user's home folder and assigned 600 permissions.

## ```now.sh```

Bash script that prints the current timnestamp in the format ```+%y-%m-%d_%H_%M_%S_UTC```

Usage:
```Bash
Bash ./now.sh
```

## ```email.sh```

Bash utility script that sends emails. Subject and body are specified via command line arguments and the configuration parameters are read from ```.bb-dev_config```.

```Bash
Bash ./email.sh "Subject" "Absolute path to message body text file"
```

## ```runner.sh```

```runner.sh``` is being kept always running on the host in a "runner.sh" tmux session and is responsible for the persistence of the entire framework. ```runner.sh``` launches all workflows at different times/cadences, depending on the workflows.
At the current stage, ```runner.sh``` supports hourly and daily cadences. For a workflow to be picked up by ```runner.sh```, the workflow script needs to be called ```workflow#.sh```.

## ```workflow1.sh```

This workflow is all about ```subfinder``` -> ```httpx``` -> ```nuclei```.

```workflow1.sh``` is run by ```runner.sh``` at the top of every hour. It loops over programs/scopes files in the ```$home/inputs/``` folder, where all scope files have names starting with ```urls_*``` or ```_urls_*```. Files with name starting with ```urls_*``` are processed, while all programs scope files with name starting with ```_urls_*``` are ignored.

```workflow1.sh``` then processes all URLs/FQDNs in the scope files and runs each one of them thru the pipe ```subfinder``` -> ```httpx``` -> ```nuclei```. All results are saved in the ```$home/outputs/workflow1/``` folder and ```/$YEAR/$MONTH/$TIMESTAMP``` subfolders, in text files with names starting respectively with ```subfinder_*```, ```httpx_*``` and ```nuclei_*```.

Finally, ```workflow1.sh``` sends an email notification containing any unique vulnerability detected by ```nuclei``` with severity medium, high or critical.

Required underlying tools:
* ```subfinder```
* ```httpx```
* ```nuclei```
  
## ```workflow2.sh```

This workflow is all about ```subfinder``` -> ```nmap```  ->  ```nmap-vulscan```/```nmap-vulners```.

```workflow2.sh``` is run by ```runner.sh``` every day at midnight. It loops over programs/scopes files in the ```$home/inputs/``` folder, where all scope files have names starting with ```urls_*``` or ```_urls_*```. Files with name starting with ```urls_*``` are processed, while all programs scope files with name starting with ```_urls_*``` are ignored.

```workflow2.sh``` then processes all URLs/FQDNs in the scope files and runs each one of them thru the pipe ```subfinder``` -> ```nmap```. All results are saved in the ```$home/outputs/workflow2/``` folder and ```/$YEAR/$MONTH/$TIMESTAMP``` subfolders, in text files with names starting respectively with ```subfinder_*``` and ```nmap_*```.

Finally, ```workflow2.sh``` sends an email notification containing any unique detected CVE with CVSSv3 score of 8.0 or above.

Required underlying tools:
* ```subfinder```
* ```nmap```
* ```nmap-vulscan```
* ```nmap-vulners```

## ```workflow3.sh```

This workflow is all about ```subfinder``` -> ```httpx``` -> ```gau```.

```workflow3.sh``` is run by ```runner.sh``` every day at midnight. It loops over programs/scopes files in the ```$home/inputs/``` folder, where all scope files have names starting with ```urls_*``` or ```_urls_*```. Files with name starting with ```urls_*``` are processed, while all programs scope files with name starting with ```_urls_*``` are ignored.

```workflow3.sh``` then processes all URLs/FQDNs in the scope files and runs each one of them thru the pipe ```subfinder``` -> ```httpx``` -> ```gau```. All results are saved in the ```$home/outputs/workflow3/``` folder and ```/$YEAR/$MONTH/$TIMESTAMP``` subfolders, in text files with names starting respectively with ```subfinder_*```, ```httpx_*``` and ```gau_*```.

Finally, ```workflow3.sh``` sends an email notification containing any unique "interesting" URL, as defined in the workflow itself.

Required underlying tools:
* ```subfinder```
* ```httpx```
* ```gau```

## ```workflow4.sh```

This workflow is all about being notified if a website changes (i.e. gets updated) and it uses ```subfinder```, ```httpx``` and a combination of checksum technologies glued together with ```bash```.

```workflow4.sh``` is run by ```runner.sh``` every day at midnight. It loops over programs/scopes files in the ```$home/inputs/``` folder, where all scope files have names starting with ```urls_*``` or ```_urls_*```. Files with name starting with ```urls_*``` are processed, while all programs scope files with name starting with ```_urls_*``` are ignored.

```workflow4.sh``` then processes all URLs/FQDNs in the scope files and runs each one of them thru the pipe ```subfinder``` -> ```httpx```. All results are saved in the ```$home/outputs/workflow4/``` folder and ```/$YEAR/$MONTH/$TIMESTAMP``` subfolders, in text files with names starting respectively with ```subfinder_*``` and ```httpx_*```.

Finally, for each URL from ```httpx``` that returned status 200, ```workflow4.sh``` grabs the homepage, calculates the SHA512 of its content and compares it to the hash for the same URL calculated the privious time the workflow has run. Then, if the hash has changed, it sends an email notification containing the URL whose content supposedly changed.

Required underlying tools:
* ```subfinder```
* ```httpx```

# Licensing

The tool is licensed under the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).

# Legal disclaimer

Usage of this tool to interact with targets without prior mutual consent is illegal. It's the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program. Only use for educational purposes.
