# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import FallingEdge, RisingEdge

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

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test")

  await ClockCycles(dut.clk, 1)

  dut.butt_red .value = 1

  await ClockCycles(dut.clk, 1)

  dut.butt_red .value = 0
  dut.butt_yel .value = 1

  await ClockCycles(dut.clk, 1)

  dut.butt_yel .value = 0
  dut.butt_grn .value = 1

  await ClockCycles(dut.clk, 1)

  dut.butt_grn .value = 0
  dut.butt_blu .value = 1

  await ClockCycles(dut.clk, 1)

  dut.butt_blu .value = 0

  await ClockCycles(dut.clk, 1)

  dut.butt_start.value = 1

  await ClockCycles(dut.clk, 1)

  dut.butt_start.value = 0

  await ClockCycles(dut.clk, 10)

  assert True
