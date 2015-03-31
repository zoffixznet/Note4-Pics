# Note4-Pics

Perl script for downloading pictures off Samsung Galaxy Note 4 over MTP

## Installation

This script needs `mtp-tools` package. On Debian systems, install it with
```
sudo apt-get install mtp-tools
```

## Usage

Just connect your phone via USB and call run get-pics.pl. By default,
it will retrieve all the pics you've taken in the past hour.

You can use `-days` flag to retrieve pics taken in the past day.

*Note:* with Note 4, it looks like you have to reconnect your device each
time you run `get-pics.pl`. This is the case for the `mtp-getfiles`
command the script uses internally and I haven't investigated why
it behaves that way.