# log4bash

born out of frustration, having no uniform logging mechanism across bash scripts and inspired by the original **log4bash** 

## Using this fork of log4bash

**source** the *log4bash.sh* script at the beginning of any Bash program.

``` bash

    #!/usr/bin/bash
    source log4bash.sh

    log "Welcome to log4bash, log and [log "info"] do the same thing";

    log "info"  "Welcome to log4bash, did you know the average person falls asleep in 7 minutes";
    
    log "success" "Each and every turn of life all of us need motivation to achieve our goal and to be succeed..."
    
    log "warn" "typically issued in situations where it is useful to alert the user of some condition in a program..."
    
    log "error" "error messages are a fact of life in IT"

```
