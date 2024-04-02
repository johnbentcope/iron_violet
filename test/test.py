# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import FallingEdge, RisingEdge
from cocotb.triggers import Combine, First, with_timeout

random.seed(1711904743)
fail_move = random.randint(4,31)

@cocotb.test()
async def test_simon(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ui_in     .value = 0
  dut.uio_in    .value = 0
  dut.ena       .value = 0
  dut.clk       .value = 0
  dut.rst_n     .value = 1
  dut.butt_red  .value = 0
  dut.butt_yel  .value = 0
  dut.butt_grn  .value = 0
  dut.butt_blu  .value = 0
  dut.butt_start.value = 0

  await ClockCycles(dut.clk, 1)

  await reset_dut(dut)

  await start_game(dut)

  for i in range(31):
    await play_back_moves(dut, max_moves=(i))

  await ClockCycles(dut.clk, 10)

  await reset_dut(dut, 1000)

  await ClockCycles(dut.clk, 1)

  await start_game(dut, cycles=10)

  for i in range(12):
    await play_back_moves(dut, max_moves=(i+1),fail_last=(i == 11))

  await ClockCycles(dut.clk, 1000)

  await start_game(dut, cycles=15)

  for i in range(18):
    await play_back_moves(dut, max_moves=(i+1),fail_last=(i == 17))

  await ClockCycles(dut.clk, 1000)

  await start_game(dut, cycles=10)

  for i in range(15):
    await play_back_moves(dut, max_moves=(i+1),fail_last=(i == 14))

  await ClockCycles(dut.clk, 1000)
  
  assert True

async def reset_dut(dut, cycles=5):
  """
  This coroutine resets the dut. That's it.
  """

  dut.rst_n.value = 0

  await ClockCycles(dut.clk, cycles)

  dut.rst_n.value = 1

  await ClockCycles(dut.clk, 1)

async def start_game(dut, cycles=5):
  """
  This coroutine starts the game. That's it.
  """

  dut.butt_start.value = 1

  await ClockCycles(dut.clk, cycles)

  dut.butt_start.value = 0

  await ClockCycles(dut.clk, 1)

async def bounce_red(dut, end_state, cycles=5):
  """
  This coroutine bounces the red button.
  """
  
  dut.butt_red.value = end_state
  
  for _ in range(cycles):
    time.sleep(random.randint(0,10)/1000) # Delay between 0 to 10 ms
    dut.butt_red.value = not end_state

  dut.butt_red.value = end_state

async def bounce_yel(dut, end_state, cycles=5):
  """
  This coroutine bounces the yellow button.
  """
  
  dut.butt_yel.value = end_state
  
  for _ in range(cycles):
    time.sleep(random.randint(0,10)/1000) # Delay between 0 to 10 ms
    dut.butt_yel.value = not end_state

  dut.butt_yel.value = end_state
  
async def bounce_grn(dut, end_state, cycles=5):
  """
  This coroutine bounces the green button.
  """
  
  dut.butt_grn.value = end_state
  
  for _ in range(cycles):
    time.sleep(random.randint(0,10)/1000) # Delay between 0 to 10 ms
    dut.butt_grn.value = not end_state

  dut.butt_grn.value = end_state

async def bounce_blu(dut, end_state, cycles=5):
  """
  This coroutine bounces the blue button.
  """
  
  dut.butt_blu.value = end_state
  
  for _ in range(cycles):
    time.sleep(random.randint(0,10)/1000) # Delay between 0 to 10 ms
    dut.butt_blu.value = not end_state

  dut.butt_blu.value = end_state

async def play_back_moves(dut, max_moves=10, fail_last=False):
  """
  This coroutine listens to the lamp signals in parallel, stores the sequence,
  and then replays the sequence using the button signals. It adapts to the sequence
  length up to a maximum.
  """
  moves = []
  
  lamp_timeout = 100

  # Combine triggers for all lamp signals
  all_lamp_edges_rise = First(RisingEdge(dut.lamp_red), RisingEdge(dut.lamp_yel),
                           RisingEdge(dut.lamp_grn), RisingEdge(dut.lamp_blu))

  # Combine triggers for all lamp signals
  all_lamp_edges_fall = First(FallingEdge(dut.lamp_red), FallingEdge(dut.lamp_yel),
                           FallingEdge(dut.lamp_grn), FallingEdge(dut.lamp_blu))

  # Loop to listen for lamp signals
  for _ in range(max_moves):
    try:
      await with_timeout(all_lamp_edges_rise, lamp_timeout, 'us')
    except TimeoutError:
      dut._log.info("Lamp didn't rise.")
      break
    
    await ClockCycles(dut.clk, 4)  # Wait

    # Update moves based on the triggered lamp
    if dut.lamp_red == 1:
      moves.append(0)
    elif dut.lamp_yel == 1:
      moves.append(1)
    elif dut.lamp_grn == 1:
      moves.append(2)
    elif dut.lamp_blu == 1:
      moves.append(3)

    try:
      await with_timeout(all_lamp_edges_fall, lamp_timeout, 'us')
    except TimeoutError:
      dut._log.info("Lamp didn't fall.")
      break

  # playback_delay = random.randint(3,10);
  # await ClockCycles(dut.clk, playback_delay)  # Delay before playing game

  dut._log.info(moves)
  # Replay the moves with a delay between each
  for i in range(max_moves):
    move = moves[i]
    hold_cycles = random.randint(3,100);
    release_cycles = random.randint(3,100);
    await ClockCycles(dut.clk, release_cycles)  # Delay between moves
    if ((fail_last == True) and (i == max_moves-1)):
      move = 3-move
    dut.butt_red.value = dut.butt_yel.value = dut.butt_grn.value = dut.butt_blu.value = 0
    if(move == 0):
      bounce_red(dut, 1)  # Set the appropriate button high       
    elif (move == 1):
      bounce_yel(dut, 1)
    elif (move == 2):
      bounce_grn(dut, 1)
    elif (move == 3):
      bounce_blu(dut, 1)
    await ClockCycles(dut.clk, hold_cycles)  # Hold the button for 10 clock cycles
    if(move == 0):
      bounce_red(dut, 0)  # Set the appropriate button low
    elif (move == 1):
      bounce_yel(dut, 0)
    elif (move == 2):
      bounce_grn(dut, 0)
    elif (move == 3):
      bounce_blu(dut, 0)
