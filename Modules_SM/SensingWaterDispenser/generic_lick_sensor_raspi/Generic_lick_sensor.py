# Switch_maze
from switch_maze_functions import *
"""
Execution loop for lick logging and water dispensing.
Delivers a drop of water upon licking.
Next drop of water will be available after 1s.
Changes typically not recommended here.
This is an example.
"""
animaltag='001'
while True:
    # reset
    if MODE == 1:
        print("\nwater available\n")
        tick = pi.get_current_tick()
        save.append_event("*", "", "drop_available", animaltag, FED_position, tick)
        lick_timer = int(round(time.time() * 1000))
        licks = 0
        drink_delay = 0
        time_to_next = 0
        lick_flag = True
        MODE=2
    # record licking
    if MODE == 2:
        if pi.read(ard_pi_lick):
            licks = licks + 1
            water_flag = True
            if lick_flag:
                drink_delay = int(round(time.time() * 1000)) - lick_timer
                tick = pi.get_current_tick()
                save.append_event(
                    "", drink_delay, "drink", animaltag, FED_position, tick
                )
                pi.write(give_water, 1)  # give a water drop
                time.sleep(water_time)
                pi.write(give_water, 0)
                lick_flag = False
                print("DRINK")
                time_to_next=int(round(time.time() * 1000)) - drink_delay - lick_timer
    if MODE == 2 and time_to_next>1000:
        tick = pi.get_current_tick()
        save.append_event("*", licks, "lick_tally", animaltag, FED_position, tick)
        MODE=1