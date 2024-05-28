# bb-dev

First attempt at a recon automation framework, bear with me...

## Tools

### ```.bb-dev_config```

Config file to store all configuration parameters and secrets for the framework. It is meant to be stored in the user's home folder and assigned 600 permissions.

### ```now.sh```

Bash script that prints the current timnestamp in the format +%y-%m-%d_%H_%M_%S_UTC

### ```runner.sh```

```runner.sh``` is kept always running on the host in a "runner.sh" tmux session and is responsible for the persistence of the entire framework. ```runner.sh``` launches all workflows at different times/cadences, depending on the workflows.

### ```email.sh```

Bash script that...

```Bash
Bash code here
```

### ```workflow1.sh```

This workflow is all about ```subfinder``` -> ```httpx``` -> ```nuclei``` 

```workflow1.sh``` is run by ```runner.sh``` at the top of every hour.

```Bash
Bash code here
```

### ```workflow2.sh```

Bash script that...

```Bash
Bash code here
```

## TODOs

* ```workflow1.sh```
  - Aaa
  - Aaa

* ```workflow2.sh```
  - Aaa
  - Aaa

## Licensing

The tool is licensed under the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Legal disclaimer

Usage of this tool to interact with targets without prior mutual consent is illegal. It's the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program. Only use for educational purposes.
