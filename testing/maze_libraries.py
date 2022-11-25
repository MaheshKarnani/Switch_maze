import inspect

if __name__ != "__main__":
    for frame in inspect.stack()[1:]:
        if frame.filename[0] != "<":
            file = frame.filename.split("\\")[-1]

            if file == "rescue_opendoor2.py":
                import RPi.GPIO as GPIO

            elif file == "rescue_opendoor2.py":
                import RPi.GPIO as GPIO
                import os
                import pandas as pd
                import datetime
                import numpy as np
                from github import Github
                from github import InputGitTreeElement

            elif file == "Switch_maze_main.py":
                import serial
                import time
                import pigpio
                import os
                import pandas as pd
                import statistics as stats
                import datetime
                import numpy as np
                

            elif file == "RFIDreader_newcohort.py":
                import serial
                import time
                import RPi.GPIO as GPIO
                import statistics as stats
                from datetime import datetime
