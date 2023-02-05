#!/bin/bash

# TODO - create a notifications system that'll let the user know if some processes finished (as opposed to crashing or ceasing with a PC restart) or if the computer was restarted for any critical reason:
#  create a file in user's home where critical messages / notifications would be added
#    example: a system that monitors CPU temp would log there before shutting down the computer for safety in case abnormal temps were reached
# the file should be read on startup and the errors displayed in a pop-up/notification (or just a message at the start of terminal).
# messages should be cleared with a custom command (specified in the message) and if possible, when user clicks that he's read the popup.
