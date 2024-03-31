# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import FallingEdge, RisingEdge
from cocotb.triggers import Combine, First, with_timeout

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
  dut.rst_n     .value = 0
  dut.butt_red  .value = 0
  dut.butt_yel  .value = 0
  dut.butt_grn  .value = 0
  dut.butt_blu  .value = 0
  dut.butt_start.value = 0

  await ClockCycles(dut.clk, 5)

  dut.rst_n .value = 1

  await ClockCycles(dut.clk, 1)

  dut.butt_start.value = 1

  await ClockCycles(dut.clk, 1)

  dut.butt_start.value = 0

  for i in range(31):
    await play_back_moves(dut, max_moves=(i+1))

  await ClockCycles(dut.clk, 1)
  
  assert True

async def play_back_moves(dut, max_moves=10):
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


    # Update move based on the triggered lamp
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



  dut._log.info(moves)
  # Replay the moves with a delay between each
  for move in moves:
    dut.butt_red.value = dut.butt_yel.value = dut.butt_grn.value = dut.butt_blu.value = 0
    if(move == 0):
      dut.butt_red.value = 1  # Set the appropriate button high
    elif (move == 1):
      dut.butt_yel.value = 1
    elif (move == 2):
      dut.butt_grn.value = 1
    elif (move == 3):
      dut.butt_blu.value = 1
    await ClockCycles(dut.clk, 1)  # Hold the button for 10 clock cycles
    if(move == 0):
      dut.butt_red.value = 0  # Set the appropriate button low
    elif (move == 1):
      dut.butt_yel.value = 0
    elif (move == 2):
      dut.butt_grn.value = 0
    elif (move == 3):
      dut.butt_blu.value = 0
    await ClockCycles(dut.clk, 1)  # Delay between moves
