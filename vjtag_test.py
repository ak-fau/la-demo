#!/usr/bin/env python3
"""
In-FPGA Logic Analyzer test via Altera/Intel Virtual JTAG and OpenOCD RPC

Copyright (C) 2020 Anton Kuzmin <anton.kuzmin@cs.fau.de>

Based on
  OpenOCD RPC example, covered by GNU GPLv3 or later
  Copyright (C) 2014 Andreas Ortmann (ortmann@finf.uni-hannover.de)
"""

import socket

class OpenOcd:
    COMMAND_TOKEN = '\x1a'
    def __init__(self, verbose=False):
        self.verbose = verbose
        self.tclRpcIp       = "127.0.0.1"
        self.tclRpcPort     = 6666
        self.bufferSize     = 4096

        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def __enter__(self):
        self.connect()
        return self

    def __exit__(self, type, value, traceback):
        self.disconnect()

    def connect(self):
        self.sock.connect((self.tclRpcIp, self.tclRpcPort))

    def disconnect(self):
        try:
            self.send("exit")
        finally:
            self.sock.close()

    def send(self, cmd):
        """Send a command string to TCL RPC. Return the result that was read."""
        data = (cmd + OpenOcd.COMMAND_TOKEN).encode("utf-8")
        if self.verbose:
            print("<- ", data)

        self.sock.send(data)
        return self._recv()

    def _recv(self):
        """Read from the stream until the token (\x1a) was received."""
        data = bytes()
        while True:
            chunk = self.sock.recv(self.bufferSize)
            data += chunk
            if bytes(OpenOcd.COMMAND_TOKEN, encoding="utf-8") in chunk:
                break

        if self.verbose:
            print("-> ", data)

        data = data.decode("utf-8").strip()
        data = data[:-1] # strip trailing \x1a

        return data

if __name__ == "__main__":
    import argparse
    from time import sleep

    parser = argparse.ArgumentParser(description='Test script to talk to in-FPGA Logic Analyzer via Virtual JTAG interface')
    parser.add_argument('-d', '--debug',  action='store_true', help='Debug output: print out all sent command and received replies')
    args = parser.parse_args()

    with OpenOcd(verbose=args.debug) as ocd:
        tap = 'max10.fpga'
        ocd.send("vir_scan %s 0x11" % tap)
        for i in range(8):
            ocd.send("vdr_scan %s 8 0x%02x" % (tap, (2**i)))
            sleep(.2)
        ocd.send("vdr_scan %s 8 0" % tap)
        ocd.send("vir_scan %s 0x10" % tap)
