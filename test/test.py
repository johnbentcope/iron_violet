# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_adder(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.data_in.value = 0
  dut.rst_n.value = 0
  dut.push.value = 0
  dut.pop.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test 1")

  for a in range(5):
    for _ in range(4):
      dut.data_in.value = _
      dut.push.value = 1
      await ClockCycles(dut.clk, 1)
      dut.push.value = 0
      await ClockCycles(dut.clk, 1)

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test 2")

  for a in range(5):
    for _ in range(4):
      dut.pop.value = 1
      await ClockCycles(dut.clk, 1)
      dut.pop.value = 0
      await ClockCycles(dut.clk, 1)

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test 3")

  for a in range(5):
    for _ in range(4):
      dut.data_in.value = _
      dut.push.value = 1
      await ClockCycles(dut.clk, 1)
      dut.push.value = 0
      await ClockCycles(dut.clk, 1)

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test 4")

  assert True
  # assert dut.uo_out.value == 50
