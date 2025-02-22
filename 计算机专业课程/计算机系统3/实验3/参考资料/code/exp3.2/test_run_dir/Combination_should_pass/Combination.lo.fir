circuit Combination :
  module Decoder :
    input clock : Clock
    input reset : UInt<1>
    input io_Instr_word : UInt<32>
    output io_add_op : UInt<1>
    output io_sub_op : UInt<1>
    output io_lw_op : UInt<1>
    output io_sw_op : UInt<1>
    output io_nop_op : UInt<1>

    node opcode = bits(io_Instr_word, 31, 26) @[Instruction.scala 25:31]
    node func = bits(io_Instr_word, 5, 0) @[Instruction.scala 26:29]
    node _T = eq(opcode, UInt<6>("h0")) @[Instruction.scala 36:18]
    node _T_1 = eq(func, UInt<6>("h20")) @[Instruction.scala 37:20]
    node _T_2 = eq(func, UInt<6>("h22")) @[Instruction.scala 40:26]
    node _GEN_0 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[Instruction.scala 30:15 40:41 41:19]
    node _GEN_1 = mux(_T_2, UInt<1>("h0"), UInt<1>("h1")) @[Instruction.scala 33:15 40:41 42:19]
    node _GEN_2 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[Instruction.scala 29:15 37:35 38:19]
    node _GEN_3 = mux(_T_1, UInt<1>("h0"), _GEN_1) @[Instruction.scala 37:35 39:19]
    node _GEN_4 = mux(_T_1, UInt<1>("h0"), _GEN_0) @[Instruction.scala 30:15 37:35]
    node _T_3 = eq(opcode, UInt<6>("h23")) @[Instruction.scala 44:24]
    node _T_4 = eq(opcode, UInt<6>("h2b")) @[Instruction.scala 47:24]
    node _GEN_5 = mux(_T_4, UInt<1>("h1"), UInt<1>("h0")) @[Instruction.scala 32:14 47:39 48:18]
    node _GEN_6 = mux(_T_4, UInt<1>("h0"), UInt<1>("h1")) @[Instruction.scala 33:15 47:39 49:19]
    node _GEN_7 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Instruction.scala 31:14 44:39 45:18]
    node _GEN_8 = mux(_T_3, UInt<1>("h0"), _GEN_6) @[Instruction.scala 44:39 46:19]
    node _GEN_9 = mux(_T_3, UInt<1>("h0"), _GEN_5) @[Instruction.scala 32:14 44:39]
    node _GEN_10 = mux(_T, _GEN_2, UInt<1>("h0")) @[Instruction.scala 29:15 36:29]
    node _GEN_11 = mux(_T, _GEN_3, _GEN_8) @[Instruction.scala 36:29]
    node _GEN_12 = mux(_T, _GEN_4, UInt<1>("h0")) @[Instruction.scala 30:15 36:29]
    node _GEN_13 = mux(_T, UInt<1>("h0"), _GEN_7) @[Instruction.scala 31:14 36:29]
    node _GEN_14 = mux(_T, UInt<1>("h0"), _GEN_9) @[Instruction.scala 32:14 36:29]
    io_add_op <= _GEN_10
    io_sub_op <= _GEN_12
    io_lw_op <= _GEN_13
    io_sw_op <= _GEN_14
    io_nop_op <= _GEN_11

  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input io_RS1 : UInt<5>
    input io_RS2 : UInt<5>
    output io_RS1_out : UInt<32>
    output io_RS2_out : UInt<32>
    input io_Reg_WB : UInt<1>
    input io_WB_data : UInt<32>

    reg registers_0 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_0) @[Instruction.scala 67:28]
    reg registers_1 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_1) @[Instruction.scala 67:28]
    reg registers_2 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_2) @[Instruction.scala 67:28]
    reg registers_3 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_3) @[Instruction.scala 67:28]
    reg registers_4 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_4) @[Instruction.scala 67:28]
    reg registers_5 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_5) @[Instruction.scala 67:28]
    reg registers_6 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_6) @[Instruction.scala 67:28]
    reg registers_7 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_7) @[Instruction.scala 67:28]
    reg registers_8 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_8) @[Instruction.scala 67:28]
    reg registers_9 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_9) @[Instruction.scala 67:28]
    reg registers_10 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_10) @[Instruction.scala 67:28]
    reg registers_11 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_11) @[Instruction.scala 67:28]
    reg registers_12 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_12) @[Instruction.scala 67:28]
    reg registers_13 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_13) @[Instruction.scala 67:28]
    reg registers_14 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_14) @[Instruction.scala 67:28]
    reg registers_15 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_15) @[Instruction.scala 67:28]
    reg registers_16 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_16) @[Instruction.scala 67:28]
    reg registers_17 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_17) @[Instruction.scala 67:28]
    reg registers_18 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_18) @[Instruction.scala 67:28]
    reg registers_19 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_19) @[Instruction.scala 67:28]
    reg registers_20 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_20) @[Instruction.scala 67:28]
    reg registers_21 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_21) @[Instruction.scala 67:28]
    reg registers_22 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_22) @[Instruction.scala 67:28]
    reg registers_23 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_23) @[Instruction.scala 67:28]
    reg registers_24 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_24) @[Instruction.scala 67:28]
    reg registers_25 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_25) @[Instruction.scala 67:28]
    reg registers_26 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_26) @[Instruction.scala 67:28]
    reg registers_27 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_27) @[Instruction.scala 67:28]
    reg registers_28 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_28) @[Instruction.scala 67:28]
    reg registers_29 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_29) @[Instruction.scala 67:28]
    reg registers_30 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_30) @[Instruction.scala 67:28]
    reg registers_31 : UInt<32>, clock with :
      reset => (UInt<1>("h0"), registers_31) @[Instruction.scala 67:28]
    node _io_RS1_out_T = eq(io_RS1, UInt<1>("h0")) @[Instruction.scala 69:30]
    node _GEN_0 = validif(eq(UInt<1>("h0"), io_RS1), registers_0) @[Instruction.scala 69:{22,22}]
    node _GEN_1 = mux(eq(UInt<1>("h1"), io_RS1), registers_1, _GEN_0) @[Instruction.scala 69:{22,22}]
    node _GEN_2 = mux(eq(UInt<2>("h2"), io_RS1), registers_2, _GEN_1) @[Instruction.scala 69:{22,22}]
    node _GEN_3 = mux(eq(UInt<2>("h3"), io_RS1), registers_3, _GEN_2) @[Instruction.scala 69:{22,22}]
    node _GEN_4 = mux(eq(UInt<3>("h4"), io_RS1), registers_4, _GEN_3) @[Instruction.scala 69:{22,22}]
    node _GEN_5 = mux(eq(UInt<3>("h5"), io_RS1), registers_5, _GEN_4) @[Instruction.scala 69:{22,22}]
    node _GEN_6 = mux(eq(UInt<3>("h6"), io_RS1), registers_6, _GEN_5) @[Instruction.scala 69:{22,22}]
    node _GEN_7 = mux(eq(UInt<3>("h7"), io_RS1), registers_7, _GEN_6) @[Instruction.scala 69:{22,22}]
    node _GEN_8 = mux(eq(UInt<4>("h8"), io_RS1), registers_8, _GEN_7) @[Instruction.scala 69:{22,22}]
    node _GEN_9 = mux(eq(UInt<4>("h9"), io_RS1), registers_9, _GEN_8) @[Instruction.scala 69:{22,22}]
    node _GEN_10 = mux(eq(UInt<4>("ha"), io_RS1), registers_10, _GEN_9) @[Instruction.scala 69:{22,22}]
    node _GEN_11 = mux(eq(UInt<4>("hb"), io_RS1), registers_11, _GEN_10) @[Instruction.scala 69:{22,22}]
    node _GEN_12 = mux(eq(UInt<4>("hc"), io_RS1), registers_12, _GEN_11) @[Instruction.scala 69:{22,22}]
    node _GEN_13 = mux(eq(UInt<4>("hd"), io_RS1), registers_13, _GEN_12) @[Instruction.scala 69:{22,22}]
    node _GEN_14 = mux(eq(UInt<4>("he"), io_RS1), registers_14, _GEN_13) @[Instruction.scala 69:{22,22}]
    node _GEN_15 = mux(eq(UInt<4>("hf"), io_RS1), registers_15, _GEN_14) @[Instruction.scala 69:{22,22}]
    node _GEN_16 = mux(eq(UInt<5>("h10"), io_RS1), registers_16, _GEN_15) @[Instruction.scala 69:{22,22}]
    node _GEN_17 = mux(eq(UInt<5>("h11"), io_RS1), registers_17, _GEN_16) @[Instruction.scala 69:{22,22}]
    node _GEN_18 = mux(eq(UInt<5>("h12"), io_RS1), registers_18, _GEN_17) @[Instruction.scala 69:{22,22}]
    node _GEN_19 = mux(eq(UInt<5>("h13"), io_RS1), registers_19, _GEN_18) @[Instruction.scala 69:{22,22}]
    node _GEN_20 = mux(eq(UInt<5>("h14"), io_RS1), registers_20, _GEN_19) @[Instruction.scala 69:{22,22}]
    node _GEN_21 = mux(eq(UInt<5>("h15"), io_RS1), registers_21, _GEN_20) @[Instruction.scala 69:{22,22}]
    node _GEN_22 = mux(eq(UInt<5>("h16"), io_RS1), registers_22, _GEN_21) @[Instruction.scala 69:{22,22}]
    node _GEN_23 = mux(eq(UInt<5>("h17"), io_RS1), registers_23, _GEN_22) @[Instruction.scala 69:{22,22}]
    node _GEN_24 = mux(eq(UInt<5>("h18"), io_RS1), registers_24, _GEN_23) @[Instruction.scala 69:{22,22}]
    node _GEN_25 = mux(eq(UInt<5>("h19"), io_RS1), registers_25, _GEN_24) @[Instruction.scala 69:{22,22}]
    node _GEN_26 = mux(eq(UInt<5>("h1a"), io_RS1), registers_26, _GEN_25) @[Instruction.scala 69:{22,22}]
    node _GEN_27 = mux(eq(UInt<5>("h1b"), io_RS1), registers_27, _GEN_26) @[Instruction.scala 69:{22,22}]
    node _GEN_28 = mux(eq(UInt<5>("h1c"), io_RS1), registers_28, _GEN_27) @[Instruction.scala 69:{22,22}]
    node _GEN_29 = mux(eq(UInt<5>("h1d"), io_RS1), registers_29, _GEN_28) @[Instruction.scala 69:{22,22}]
    node _GEN_30 = mux(eq(UInt<5>("h1e"), io_RS1), registers_30, _GEN_29) @[Instruction.scala 69:{22,22}]
    node _GEN_31 = mux(eq(UInt<5>("h1f"), io_RS1), registers_31, _GEN_30) @[Instruction.scala 69:{22,22}]
    node _registers_io_RS1 = _GEN_31 @[Instruction.scala 69:22]
    node _io_RS1_out_T_1 = mux(_io_RS1_out_T, UInt<1>("h0"), _registers_io_RS1) @[Instruction.scala 69:22]
    node _io_RS2_out_T = eq(io_RS2, UInt<1>("h0")) @[Instruction.scala 70:30]
    node _GEN_32 = validif(eq(UInt<1>("h0"), io_RS2), registers_0) @[Instruction.scala 70:{22,22}]
    node _GEN_33 = mux(eq(UInt<1>("h1"), io_RS2), registers_1, _GEN_32) @[Instruction.scala 70:{22,22}]
    node _GEN_34 = mux(eq(UInt<2>("h2"), io_RS2), registers_2, _GEN_33) @[Instruction.scala 70:{22,22}]
    node _GEN_35 = mux(eq(UInt<2>("h3"), io_RS2), registers_3, _GEN_34) @[Instruction.scala 70:{22,22}]
    node _GEN_36 = mux(eq(UInt<3>("h4"), io_RS2), registers_4, _GEN_35) @[Instruction.scala 70:{22,22}]
    node _GEN_37 = mux(eq(UInt<3>("h5"), io_RS2), registers_5, _GEN_36) @[Instruction.scala 70:{22,22}]
    node _GEN_38 = mux(eq(UInt<3>("h6"), io_RS2), registers_6, _GEN_37) @[Instruction.scala 70:{22,22}]
    node _GEN_39 = mux(eq(UInt<3>("h7"), io_RS2), registers_7, _GEN_38) @[Instruction.scala 70:{22,22}]
    node _GEN_40 = mux(eq(UInt<4>("h8"), io_RS2), registers_8, _GEN_39) @[Instruction.scala 70:{22,22}]
    node _GEN_41 = mux(eq(UInt<4>("h9"), io_RS2), registers_9, _GEN_40) @[Instruction.scala 70:{22,22}]
    node _GEN_42 = mux(eq(UInt<4>("ha"), io_RS2), registers_10, _GEN_41) @[Instruction.scala 70:{22,22}]
    node _GEN_43 = mux(eq(UInt<4>("hb"), io_RS2), registers_11, _GEN_42) @[Instruction.scala 70:{22,22}]
    node _GEN_44 = mux(eq(UInt<4>("hc"), io_RS2), registers_12, _GEN_43) @[Instruction.scala 70:{22,22}]
    node _GEN_45 = mux(eq(UInt<4>("hd"), io_RS2), registers_13, _GEN_44) @[Instruction.scala 70:{22,22}]
    node _GEN_46 = mux(eq(UInt<4>("he"), io_RS2), registers_14, _GEN_45) @[Instruction.scala 70:{22,22}]
    node _GEN_47 = mux(eq(UInt<4>("hf"), io_RS2), registers_15, _GEN_46) @[Instruction.scala 70:{22,22}]
    node _GEN_48 = mux(eq(UInt<5>("h10"), io_RS2), registers_16, _GEN_47) @[Instruction.scala 70:{22,22}]
    node _GEN_49 = mux(eq(UInt<5>("h11"), io_RS2), registers_17, _GEN_48) @[Instruction.scala 70:{22,22}]
    node _GEN_50 = mux(eq(UInt<5>("h12"), io_RS2), registers_18, _GEN_49) @[Instruction.scala 70:{22,22}]
    node _GEN_51 = mux(eq(UInt<5>("h13"), io_RS2), registers_19, _GEN_50) @[Instruction.scala 70:{22,22}]
    node _GEN_52 = mux(eq(UInt<5>("h14"), io_RS2), registers_20, _GEN_51) @[Instruction.scala 70:{22,22}]
    node _GEN_53 = mux(eq(UInt<5>("h15"), io_RS2), registers_21, _GEN_52) @[Instruction.scala 70:{22,22}]
    node _GEN_54 = mux(eq(UInt<5>("h16"), io_RS2), registers_22, _GEN_53) @[Instruction.scala 70:{22,22}]
    node _GEN_55 = mux(eq(UInt<5>("h17"), io_RS2), registers_23, _GEN_54) @[Instruction.scala 70:{22,22}]
    node _GEN_56 = mux(eq(UInt<5>("h18"), io_RS2), registers_24, _GEN_55) @[Instruction.scala 70:{22,22}]
    node _GEN_57 = mux(eq(UInt<5>("h19"), io_RS2), registers_25, _GEN_56) @[Instruction.scala 70:{22,22}]
    node _GEN_58 = mux(eq(UInt<5>("h1a"), io_RS2), registers_26, _GEN_57) @[Instruction.scala 70:{22,22}]
    node _GEN_59 = mux(eq(UInt<5>("h1b"), io_RS2), registers_27, _GEN_58) @[Instruction.scala 70:{22,22}]
    node _GEN_60 = mux(eq(UInt<5>("h1c"), io_RS2), registers_28, _GEN_59) @[Instruction.scala 70:{22,22}]
    node _GEN_61 = mux(eq(UInt<5>("h1d"), io_RS2), registers_29, _GEN_60) @[Instruction.scala 70:{22,22}]
    node _GEN_62 = mux(eq(UInt<5>("h1e"), io_RS2), registers_30, _GEN_61) @[Instruction.scala 70:{22,22}]
    node _GEN_63 = mux(eq(UInt<5>("h1f"), io_RS2), registers_31, _GEN_62) @[Instruction.scala 70:{22,22}]
    node _registers_io_RS2 = _GEN_63 @[Instruction.scala 70:22]
    node _io_RS2_out_T_1 = mux(_io_RS2_out_T, UInt<1>("h0"), _registers_io_RS2) @[Instruction.scala 70:22]
    node _registers_T = eq(io_RS1, UInt<1>("h0")) @[Instruction.scala 74:41]
    node _registers_T_1 = mux(_registers_T, UInt<1>("h0"), io_WB_data) @[Instruction.scala 74:33]
    node _registers_io_RS1_0 = _registers_T_1 @[Instruction.scala 74:{27,27}]
    node _GEN_64 = mux(eq(UInt<1>("h0"), io_RS1), _registers_io_RS1_0, registers_0) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_65 = mux(eq(UInt<1>("h1"), io_RS1), _registers_io_RS1_0, registers_1) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_66 = mux(eq(UInt<2>("h2"), io_RS1), _registers_io_RS1_0, registers_2) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_67 = mux(eq(UInt<2>("h3"), io_RS1), _registers_io_RS1_0, registers_3) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_68 = mux(eq(UInt<3>("h4"), io_RS1), _registers_io_RS1_0, registers_4) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_69 = mux(eq(UInt<3>("h5"), io_RS1), _registers_io_RS1_0, registers_5) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_70 = mux(eq(UInt<3>("h6"), io_RS1), _registers_io_RS1_0, registers_6) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_71 = mux(eq(UInt<3>("h7"), io_RS1), _registers_io_RS1_0, registers_7) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_72 = mux(eq(UInt<4>("h8"), io_RS1), _registers_io_RS1_0, registers_8) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_73 = mux(eq(UInt<4>("h9"), io_RS1), _registers_io_RS1_0, registers_9) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_74 = mux(eq(UInt<4>("ha"), io_RS1), _registers_io_RS1_0, registers_10) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_75 = mux(eq(UInt<4>("hb"), io_RS1), _registers_io_RS1_0, registers_11) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_76 = mux(eq(UInt<4>("hc"), io_RS1), _registers_io_RS1_0, registers_12) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_77 = mux(eq(UInt<4>("hd"), io_RS1), _registers_io_RS1_0, registers_13) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_78 = mux(eq(UInt<4>("he"), io_RS1), _registers_io_RS1_0, registers_14) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_79 = mux(eq(UInt<4>("hf"), io_RS1), _registers_io_RS1_0, registers_15) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_80 = mux(eq(UInt<5>("h10"), io_RS1), _registers_io_RS1_0, registers_16) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_81 = mux(eq(UInt<5>("h11"), io_RS1), _registers_io_RS1_0, registers_17) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_82 = mux(eq(UInt<5>("h12"), io_RS1), _registers_io_RS1_0, registers_18) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_83 = mux(eq(UInt<5>("h13"), io_RS1), _registers_io_RS1_0, registers_19) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_84 = mux(eq(UInt<5>("h14"), io_RS1), _registers_io_RS1_0, registers_20) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_85 = mux(eq(UInt<5>("h15"), io_RS1), _registers_io_RS1_0, registers_21) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_86 = mux(eq(UInt<5>("h16"), io_RS1), _registers_io_RS1_0, registers_22) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_87 = mux(eq(UInt<5>("h17"), io_RS1), _registers_io_RS1_0, registers_23) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_88 = mux(eq(UInt<5>("h18"), io_RS1), _registers_io_RS1_0, registers_24) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_89 = mux(eq(UInt<5>("h19"), io_RS1), _registers_io_RS1_0, registers_25) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_90 = mux(eq(UInt<5>("h1a"), io_RS1), _registers_io_RS1_0, registers_26) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_91 = mux(eq(UInt<5>("h1b"), io_RS1), _registers_io_RS1_0, registers_27) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_92 = mux(eq(UInt<5>("h1c"), io_RS1), _registers_io_RS1_0, registers_28) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_93 = mux(eq(UInt<5>("h1d"), io_RS1), _registers_io_RS1_0, registers_29) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_94 = mux(eq(UInt<5>("h1e"), io_RS1), _registers_io_RS1_0, registers_30) @[Instruction.scala 74:{27,27} 67:28]
    node _GEN_95 = mux(eq(UInt<5>("h1f"), io_RS1), _registers_io_RS1_0, registers_31) @[Instruction.scala 74:{27,27} 67:28]
    node _registers_T_2 = eq(io_RS2, UInt<1>("h0")) @[Instruction.scala 75:41]
    node _registers_T_3 = mux(_registers_T_2, UInt<1>("h0"), io_WB_data) @[Instruction.scala 75:33]
    node _registers_io_RS2_0 = _registers_T_3 @[Instruction.scala 75:{27,27}]
    node _GEN_96 = mux(eq(UInt<1>("h0"), io_RS2), _registers_io_RS2_0, _GEN_64) @[Instruction.scala 75:{27,27}]
    node _GEN_97 = mux(eq(UInt<1>("h1"), io_RS2), _registers_io_RS2_0, _GEN_65) @[Instruction.scala 75:{27,27}]
    node _GEN_98 = mux(eq(UInt<2>("h2"), io_RS2), _registers_io_RS2_0, _GEN_66) @[Instruction.scala 75:{27,27}]
    node _GEN_99 = mux(eq(UInt<2>("h3"), io_RS2), _registers_io_RS2_0, _GEN_67) @[Instruction.scala 75:{27,27}]
    node _GEN_100 = mux(eq(UInt<3>("h4"), io_RS2), _registers_io_RS2_0, _GEN_68) @[Instruction.scala 75:{27,27}]
    node _GEN_101 = mux(eq(UInt<3>("h5"), io_RS2), _registers_io_RS2_0, _GEN_69) @[Instruction.scala 75:{27,27}]
    node _GEN_102 = mux(eq(UInt<3>("h6"), io_RS2), _registers_io_RS2_0, _GEN_70) @[Instruction.scala 75:{27,27}]
    node _GEN_103 = mux(eq(UInt<3>("h7"), io_RS2), _registers_io_RS2_0, _GEN_71) @[Instruction.scala 75:{27,27}]
    node _GEN_104 = mux(eq(UInt<4>("h8"), io_RS2), _registers_io_RS2_0, _GEN_72) @[Instruction.scala 75:{27,27}]
    node _GEN_105 = mux(eq(UInt<4>("h9"), io_RS2), _registers_io_RS2_0, _GEN_73) @[Instruction.scala 75:{27,27}]
    node _GEN_106 = mux(eq(UInt<4>("ha"), io_RS2), _registers_io_RS2_0, _GEN_74) @[Instruction.scala 75:{27,27}]
    node _GEN_107 = mux(eq(UInt<4>("hb"), io_RS2), _registers_io_RS2_0, _GEN_75) @[Instruction.scala 75:{27,27}]
    node _GEN_108 = mux(eq(UInt<4>("hc"), io_RS2), _registers_io_RS2_0, _GEN_76) @[Instruction.scala 75:{27,27}]
    node _GEN_109 = mux(eq(UInt<4>("hd"), io_RS2), _registers_io_RS2_0, _GEN_77) @[Instruction.scala 75:{27,27}]
    node _GEN_110 = mux(eq(UInt<4>("he"), io_RS2), _registers_io_RS2_0, _GEN_78) @[Instruction.scala 75:{27,27}]
    node _GEN_111 = mux(eq(UInt<4>("hf"), io_RS2), _registers_io_RS2_0, _GEN_79) @[Instruction.scala 75:{27,27}]
    node _GEN_112 = mux(eq(UInt<5>("h10"), io_RS2), _registers_io_RS2_0, _GEN_80) @[Instruction.scala 75:{27,27}]
    node _GEN_113 = mux(eq(UInt<5>("h11"), io_RS2), _registers_io_RS2_0, _GEN_81) @[Instruction.scala 75:{27,27}]
    node _GEN_114 = mux(eq(UInt<5>("h12"), io_RS2), _registers_io_RS2_0, _GEN_82) @[Instruction.scala 75:{27,27}]
    node _GEN_115 = mux(eq(UInt<5>("h13"), io_RS2), _registers_io_RS2_0, _GEN_83) @[Instruction.scala 75:{27,27}]
    node _GEN_116 = mux(eq(UInt<5>("h14"), io_RS2), _registers_io_RS2_0, _GEN_84) @[Instruction.scala 75:{27,27}]
    node _GEN_117 = mux(eq(UInt<5>("h15"), io_RS2), _registers_io_RS2_0, _GEN_85) @[Instruction.scala 75:{27,27}]
    node _GEN_118 = mux(eq(UInt<5>("h16"), io_RS2), _registers_io_RS2_0, _GEN_86) @[Instruction.scala 75:{27,27}]
    node _GEN_119 = mux(eq(UInt<5>("h17"), io_RS2), _registers_io_RS2_0, _GEN_87) @[Instruction.scala 75:{27,27}]
    node _GEN_120 = mux(eq(UInt<5>("h18"), io_RS2), _registers_io_RS2_0, _GEN_88) @[Instruction.scala 75:{27,27}]
    node _GEN_121 = mux(eq(UInt<5>("h19"), io_RS2), _registers_io_RS2_0, _GEN_89) @[Instruction.scala 75:{27,27}]
    node _GEN_122 = mux(eq(UInt<5>("h1a"), io_RS2), _registers_io_RS2_0, _GEN_90) @[Instruction.scala 75:{27,27}]
    node _GEN_123 = mux(eq(UInt<5>("h1b"), io_RS2), _registers_io_RS2_0, _GEN_91) @[Instruction.scala 75:{27,27}]
    node _GEN_124 = mux(eq(UInt<5>("h1c"), io_RS2), _registers_io_RS2_0, _GEN_92) @[Instruction.scala 75:{27,27}]
    node _GEN_125 = mux(eq(UInt<5>("h1d"), io_RS2), _registers_io_RS2_0, _GEN_93) @[Instruction.scala 75:{27,27}]
    node _GEN_126 = mux(eq(UInt<5>("h1e"), io_RS2), _registers_io_RS2_0, _GEN_94) @[Instruction.scala 75:{27,27}]
    node _GEN_127 = mux(eq(UInt<5>("h1f"), io_RS2), _registers_io_RS2_0, _GEN_95) @[Instruction.scala 75:{27,27}]
    node _GEN_128 = mux(io_Reg_WB, _GEN_96, registers_0) @[Instruction.scala 73:22 67:28]
    node _GEN_129 = mux(io_Reg_WB, _GEN_97, registers_1) @[Instruction.scala 73:22 67:28]
    node _GEN_130 = mux(io_Reg_WB, _GEN_98, registers_2) @[Instruction.scala 73:22 67:28]
    node _GEN_131 = mux(io_Reg_WB, _GEN_99, registers_3) @[Instruction.scala 73:22 67:28]
    node _GEN_132 = mux(io_Reg_WB, _GEN_100, registers_4) @[Instruction.scala 73:22 67:28]
    node _GEN_133 = mux(io_Reg_WB, _GEN_101, registers_5) @[Instruction.scala 73:22 67:28]
    node _GEN_134 = mux(io_Reg_WB, _GEN_102, registers_6) @[Instruction.scala 73:22 67:28]
    node _GEN_135 = mux(io_Reg_WB, _GEN_103, registers_7) @[Instruction.scala 73:22 67:28]
    node _GEN_136 = mux(io_Reg_WB, _GEN_104, registers_8) @[Instruction.scala 73:22 67:28]
    node _GEN_137 = mux(io_Reg_WB, _GEN_105, registers_9) @[Instruction.scala 73:22 67:28]
    node _GEN_138 = mux(io_Reg_WB, _GEN_106, registers_10) @[Instruction.scala 73:22 67:28]
    node _GEN_139 = mux(io_Reg_WB, _GEN_107, registers_11) @[Instruction.scala 73:22 67:28]
    node _GEN_140 = mux(io_Reg_WB, _GEN_108, registers_12) @[Instruction.scala 73:22 67:28]
    node _GEN_141 = mux(io_Reg_WB, _GEN_109, registers_13) @[Instruction.scala 73:22 67:28]
    node _GEN_142 = mux(io_Reg_WB, _GEN_110, registers_14) @[Instruction.scala 73:22 67:28]
    node _GEN_143 = mux(io_Reg_WB, _GEN_111, registers_15) @[Instruction.scala 73:22 67:28]
    node _GEN_144 = mux(io_Reg_WB, _GEN_112, registers_16) @[Instruction.scala 73:22 67:28]
    node _GEN_145 = mux(io_Reg_WB, _GEN_113, registers_17) @[Instruction.scala 73:22 67:28]
    node _GEN_146 = mux(io_Reg_WB, _GEN_114, registers_18) @[Instruction.scala 73:22 67:28]
    node _GEN_147 = mux(io_Reg_WB, _GEN_115, registers_19) @[Instruction.scala 73:22 67:28]
    node _GEN_148 = mux(io_Reg_WB, _GEN_116, registers_20) @[Instruction.scala 73:22 67:28]
    node _GEN_149 = mux(io_Reg_WB, _GEN_117, registers_21) @[Instruction.scala 73:22 67:28]
    node _GEN_150 = mux(io_Reg_WB, _GEN_118, registers_22) @[Instruction.scala 73:22 67:28]
    node _GEN_151 = mux(io_Reg_WB, _GEN_119, registers_23) @[Instruction.scala 73:22 67:28]
    node _GEN_152 = mux(io_Reg_WB, _GEN_120, registers_24) @[Instruction.scala 73:22 67:28]
    node _GEN_153 = mux(io_Reg_WB, _GEN_121, registers_25) @[Instruction.scala 73:22 67:28]
    node _GEN_154 = mux(io_Reg_WB, _GEN_122, registers_26) @[Instruction.scala 73:22 67:28]
    node _GEN_155 = mux(io_Reg_WB, _GEN_123, registers_27) @[Instruction.scala 73:22 67:28]
    node _GEN_156 = mux(io_Reg_WB, _GEN_124, registers_28) @[Instruction.scala 73:22 67:28]
    node _GEN_157 = mux(io_Reg_WB, _GEN_125, registers_29) @[Instruction.scala 73:22 67:28]
    node _GEN_158 = mux(io_Reg_WB, _GEN_126, registers_30) @[Instruction.scala 73:22 67:28]
    node _GEN_159 = mux(io_Reg_WB, _GEN_127, registers_31) @[Instruction.scala 73:22 67:28]
    node _registers_WIRE_0 = UInt<32>("h0") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_1 = UInt<32>("h1") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_2 = UInt<32>("h2") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_3 = UInt<32>("h3") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_4 = UInt<32>("h4") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_5 = UInt<32>("h5") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_6 = UInt<32>("h6") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_7 = UInt<32>("h7") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_8 = UInt<32>("h8") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_9 = UInt<32>("h9") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_10 = UInt<32>("ha") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_11 = UInt<32>("hb") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_12 = UInt<32>("hc") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_13 = UInt<32>("hd") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_14 = UInt<32>("he") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_15 = UInt<32>("hf") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_16 = UInt<32>("h10") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_17 = UInt<32>("h11") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_18 = UInt<32>("h12") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_19 = UInt<32>("h13") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_20 = UInt<32>("h14") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_21 = UInt<32>("h15") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_22 = UInt<32>("h16") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_23 = UInt<32>("h17") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_24 = UInt<32>("h18") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_25 = UInt<32>("h19") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_26 = UInt<32>("h1a") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_27 = UInt<32>("h1b") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_28 = UInt<32>("h1c") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_29 = UInt<32>("h1d") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_30 = UInt<32>("h1e") @[Instruction.scala 67:{36,36}]
    node _registers_WIRE_31 = UInt<32>("h1f") @[Instruction.scala 67:{36,36}]
    io_RS1_out <= _io_RS1_out_T_1 @[Instruction.scala 69:16]
    io_RS2_out <= _io_RS2_out_T_1 @[Instruction.scala 70:16]
    registers_0 <= mux(reset, _registers_WIRE_0, _GEN_128) @[Instruction.scala 67:{28,28}]
    registers_1 <= mux(reset, _registers_WIRE_1, _GEN_129) @[Instruction.scala 67:{28,28}]
    registers_2 <= mux(reset, _registers_WIRE_2, _GEN_130) @[Instruction.scala 67:{28,28}]
    registers_3 <= mux(reset, _registers_WIRE_3, _GEN_131) @[Instruction.scala 67:{28,28}]
    registers_4 <= mux(reset, _registers_WIRE_4, _GEN_132) @[Instruction.scala 67:{28,28}]
    registers_5 <= mux(reset, _registers_WIRE_5, _GEN_133) @[Instruction.scala 67:{28,28}]
    registers_6 <= mux(reset, _registers_WIRE_6, _GEN_134) @[Instruction.scala 67:{28,28}]
    registers_7 <= mux(reset, _registers_WIRE_7, _GEN_135) @[Instruction.scala 67:{28,28}]
    registers_8 <= mux(reset, _registers_WIRE_8, _GEN_136) @[Instruction.scala 67:{28,28}]
    registers_9 <= mux(reset, _registers_WIRE_9, _GEN_137) @[Instruction.scala 67:{28,28}]
    registers_10 <= mux(reset, _registers_WIRE_10, _GEN_138) @[Instruction.scala 67:{28,28}]
    registers_11 <= mux(reset, _registers_WIRE_11, _GEN_139) @[Instruction.scala 67:{28,28}]
    registers_12 <= mux(reset, _registers_WIRE_12, _GEN_140) @[Instruction.scala 67:{28,28}]
    registers_13 <= mux(reset, _registers_WIRE_13, _GEN_141) @[Instruction.scala 67:{28,28}]
    registers_14 <= mux(reset, _registers_WIRE_14, _GEN_142) @[Instruction.scala 67:{28,28}]
    registers_15 <= mux(reset, _registers_WIRE_15, _GEN_143) @[Instruction.scala 67:{28,28}]
    registers_16 <= mux(reset, _registers_WIRE_16, _GEN_144) @[Instruction.scala 67:{28,28}]
    registers_17 <= mux(reset, _registers_WIRE_17, _GEN_145) @[Instruction.scala 67:{28,28}]
    registers_18 <= mux(reset, _registers_WIRE_18, _GEN_146) @[Instruction.scala 67:{28,28}]
    registers_19 <= mux(reset, _registers_WIRE_19, _GEN_147) @[Instruction.scala 67:{28,28}]
    registers_20 <= mux(reset, _registers_WIRE_20, _GEN_148) @[Instruction.scala 67:{28,28}]
    registers_21 <= mux(reset, _registers_WIRE_21, _GEN_149) @[Instruction.scala 67:{28,28}]
    registers_22 <= mux(reset, _registers_WIRE_22, _GEN_150) @[Instruction.scala 67:{28,28}]
    registers_23 <= mux(reset, _registers_WIRE_23, _GEN_151) @[Instruction.scala 67:{28,28}]
    registers_24 <= mux(reset, _registers_WIRE_24, _GEN_152) @[Instruction.scala 67:{28,28}]
    registers_25 <= mux(reset, _registers_WIRE_25, _GEN_153) @[Instruction.scala 67:{28,28}]
    registers_26 <= mux(reset, _registers_WIRE_26, _GEN_154) @[Instruction.scala 67:{28,28}]
    registers_27 <= mux(reset, _registers_WIRE_27, _GEN_155) @[Instruction.scala 67:{28,28}]
    registers_28 <= mux(reset, _registers_WIRE_28, _GEN_156) @[Instruction.scala 67:{28,28}]
    registers_29 <= mux(reset, _registers_WIRE_29, _GEN_157) @[Instruction.scala 67:{28,28}]
    registers_30 <= mux(reset, _registers_WIRE_30, _GEN_158) @[Instruction.scala 67:{28,28}]
    registers_31 <= mux(reset, _registers_WIRE_31, _GEN_159) @[Instruction.scala 67:{28,28}]

  module Instruction :
    input clock : Clock
    input reset : UInt<1>
    input io_rdEna : UInt<1>
    output io_rdData : UInt<32>
    input io_wrEna : UInt<1>
    input io_wrAddr : UInt<10>
    input io_wrData : UInt<32>

    mem mem : @[Instruction.scala 94:26]
      data-type => UInt<8>
      depth => 128
      read-latency => 1
      write-latency => 1
      reader => rdData0
      reader => rdData1
      reader => rdData2
      reader => rdData3
      writer => MPORT
      writer => MPORT_1
      writer => MPORT_2
      writer => MPORT_3
      read-under-write => undefined
    reg pcReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pcReg) @[Instruction.scala 92:25]
    node _T = bits(io_wrData, 7, 0) @[Instruction.scala 99:39]
    node _T_1 = bits(io_wrAddr, 6, 0)
    node _T_2 = add(io_wrAddr, UInt<1>("h1")) @[Instruction.scala 100:29]
    node _T_3 = tail(_T_2, 1) @[Instruction.scala 100:29]
    node _T_4 = bits(io_wrData, 15, 8) @[Instruction.scala 100:45]
    node _T_5 = bits(_T_3, 6, 0)
    node _T_6 = add(io_wrAddr, UInt<2>("h2")) @[Instruction.scala 101:29]
    node _T_7 = tail(_T_6, 1) @[Instruction.scala 101:29]
    node _T_8 = bits(io_wrData, 23, 16) @[Instruction.scala 101:45]
    node _T_9 = bits(_T_7, 6, 0)
    node _T_10 = add(io_wrAddr, UInt<2>("h3")) @[Instruction.scala 102:29]
    node _T_11 = tail(_T_10, 1) @[Instruction.scala 102:29]
    node _T_12 = bits(io_wrData, 31, 24) @[Instruction.scala 102:45]
    node _T_13 = bits(_T_11, 6, 0)
    node _GEN_0 = validif(io_wrEna, _T_1) @[Instruction.scala 97:21]
    node _GEN_1 = validif(io_wrEna, clock) @[Instruction.scala 97:21]
    node _GEN_2 = mux(io_wrEna, UInt<1>("h1"), UInt<1>("h0")) @[Instruction.scala 97:21 94:26]
    node _GEN_3 = validif(io_wrEna, UInt<1>("h1")) @[Instruction.scala 97:21]
    node _GEN_4 = validif(io_wrEna, _T) @[Instruction.scala 97:21]
    node _GEN_5 = validif(io_wrEna, _T_5) @[Instruction.scala 97:21]
    node _GEN_6 = validif(io_wrEna, _T_4) @[Instruction.scala 97:21]
    node _GEN_7 = validif(io_wrEna, _T_9) @[Instruction.scala 97:21]
    node _GEN_8 = validif(io_wrEna, _T_8) @[Instruction.scala 97:21]
    node _GEN_9 = validif(io_wrEna, _T_13) @[Instruction.scala 97:21]
    node _GEN_10 = validif(io_wrEna, _T_12) @[Instruction.scala 97:21]
    node _GEN_11 = validif(UInt<1>("h1"), pcReg) @[Instruction.scala 108:{31,31}]
    node _rdData0_WIRE = _GEN_11 @[Instruction.scala 108:31]
    node _rdData0_T = or(_rdData0_WIRE, UInt<7>("h0")) @[Instruction.scala 108:31]
    node _rdData0_T_1 = bits(_rdData0_T, 6, 0) @[Instruction.scala 108:31]
    node _GEN_12 = mux(UInt<1>("h1"), UInt<1>("h1"), UInt<1>("h0")) @[Instruction.scala 108:{31,31} 94:26]
    node _GEN_13 = validif(UInt<1>("h1"), _rdData0_T_1) @[Instruction.scala 108:{31,31}]
    node _GEN_14 = validif(UInt<1>("h1"), clock) @[Instruction.scala 108:{31,31}]
    node _rdData1_T = add(pcReg, UInt<1>("h1")) @[Instruction.scala 109:37]
    node _rdData1_T_1 = tail(_rdData1_T, 1) @[Instruction.scala 109:37]
    node _GEN_15 = validif(UInt<1>("h1"), _rdData1_T_1) @[Instruction.scala 109:{31,31}]
    node _rdData1_WIRE = _GEN_15 @[Instruction.scala 109:31]
    node _rdData1_T_2 = or(_rdData1_WIRE, UInt<7>("h0")) @[Instruction.scala 109:31]
    node _rdData1_T_3 = bits(_rdData1_T_2, 6, 0) @[Instruction.scala 109:31]
    node _GEN_16 = validif(UInt<1>("h1"), _rdData1_T_3) @[Instruction.scala 109:{31,31}]
    node _rdData2_T = add(pcReg, UInt<2>("h2")) @[Instruction.scala 110:37]
    node _rdData2_T_1 = tail(_rdData2_T, 1) @[Instruction.scala 110:37]
    node _GEN_17 = validif(UInt<1>("h1"), _rdData2_T_1) @[Instruction.scala 110:{31,31}]
    node _rdData2_WIRE = _GEN_17 @[Instruction.scala 110:31]
    node _rdData2_T_2 = or(_rdData2_WIRE, UInt<7>("h0")) @[Instruction.scala 110:31]
    node _rdData2_T_3 = bits(_rdData2_T_2, 6, 0) @[Instruction.scala 110:31]
    node _GEN_18 = validif(UInt<1>("h1"), _rdData2_T_3) @[Instruction.scala 110:{31,31}]
    node _rdData3_T = add(pcReg, UInt<2>("h3")) @[Instruction.scala 111:37]
    node _rdData3_T_1 = tail(_rdData3_T, 1) @[Instruction.scala 111:37]
    node _GEN_19 = validif(UInt<1>("h1"), _rdData3_T_1) @[Instruction.scala 111:{31,31}]
    node _rdData3_WIRE = _GEN_19 @[Instruction.scala 111:31]
    node _rdData3_T_2 = or(_rdData3_WIRE, UInt<7>("h0")) @[Instruction.scala 111:31]
    node _rdData3_T_3 = bits(_rdData3_T_2, 6, 0) @[Instruction.scala 111:31]
    node _GEN_20 = validif(UInt<1>("h1"), _rdData3_T_3) @[Instruction.scala 111:{31,31}]
    node _io_rdData_T = cat(mem.rdData3.data, mem.rdData2.data) @[Instruction.scala 112:30]
    node _io_rdData_T_1 = cat(_io_rdData_T, mem.rdData1.data) @[Instruction.scala 112:41]
    node _io_rdData_T_2 = cat(_io_rdData_T_1, mem.rdData0.data) @[Instruction.scala 112:52]
    node _pcReg_T = add(pcReg, UInt<3>("h4")) @[Instruction.scala 114:24]
    node _pcReg_T_1 = tail(_pcReg_T, 1) @[Instruction.scala 114:24]
    node _GEN_21 = mux(io_rdEna, _GEN_12, UInt<1>("h0")) @[Instruction.scala 106:21 94:26]
    node _GEN_22 = validif(io_rdEna, _GEN_13) @[Instruction.scala 106:21]
    node _GEN_23 = validif(io_rdEna, _GEN_14) @[Instruction.scala 106:21]
    node _GEN_24 = validif(io_rdEna, _GEN_16) @[Instruction.scala 106:21]
    node _GEN_25 = validif(io_rdEna, _GEN_18) @[Instruction.scala 106:21]
    node _GEN_26 = validif(io_rdEna, _GEN_20) @[Instruction.scala 106:21]
    node _GEN_27 = mux(io_rdEna, _io_rdData_T_2, UInt<1>("h0")) @[Instruction.scala 106:21 112:19 116:18]
    node _GEN_28 = mux(io_rdEna, _pcReg_T_1, pcReg) @[Instruction.scala 106:21 114:15 92:25]
    io_rdData <= _GEN_27
    pcReg <= mux(reset, UInt<32>("h0"), _GEN_28) @[Instruction.scala 92:{25,25}]
    mem.rdData0.addr <= _GEN_22
    mem.rdData0.en <= _GEN_21
    mem.rdData0.clk <= _GEN_23
    mem.rdData1.addr <= _GEN_24
    mem.rdData1.en <= _GEN_21
    mem.rdData1.clk <= _GEN_23
    mem.rdData2.addr <= _GEN_25
    mem.rdData2.en <= _GEN_21
    mem.rdData2.clk <= _GEN_23
    mem.rdData3.addr <= _GEN_26
    mem.rdData3.en <= _GEN_21
    mem.rdData3.clk <= _GEN_23
    mem.MPORT.addr <= _GEN_0
    mem.MPORT.en <= _GEN_2
    mem.MPORT.clk <= _GEN_1
    mem.MPORT.data <= _GEN_4
    mem.MPORT.mask <= _GEN_3
    mem.MPORT_1.addr <= _GEN_5
    mem.MPORT_1.en <= _GEN_2
    mem.MPORT_1.clk <= _GEN_1
    mem.MPORT_1.data <= _GEN_6
    mem.MPORT_1.mask <= _GEN_3
    mem.MPORT_2.addr <= _GEN_7
    mem.MPORT_2.en <= _GEN_2
    mem.MPORT_2.clk <= _GEN_1
    mem.MPORT_2.data <= _GEN_8
    mem.MPORT_2.mask <= _GEN_3
    mem.MPORT_3.addr <= _GEN_9
    mem.MPORT_3.en <= _GEN_2
    mem.MPORT_3.clk <= _GEN_1
    mem.MPORT_3.data <= _GEN_10
    mem.MPORT_3.mask <= _GEN_3

  module Combination :
    input clock : Clock
    input reset : UInt<1>
    output io_Instr_word : UInt<32>
    output io_add_op : UInt<1>
    output io_sub_op : UInt<1>
    output io_lw_op : UInt<1>
    output io_sw_op : UInt<1>
    output io_nop_op : UInt<1>
    output io_RS1_out : UInt<32>
    output io_RS2_out : UInt<32>
    input io_rdEna : UInt<1>
    input io_wrAddr : UInt<10>
    input io_wrData : UInt<32>
    input io_wrEna : UInt<1>

    inst decoder of Decoder @[Instruction.scala 143:25]
    inst registerFile of RegisterFile @[Instruction.scala 144:30]
    inst instructionMemory of Instruction @[Instruction.scala 145:35]
    node _registerFile_io_RS1_T = bits(instructionMemory.io_rdData, 25, 21) @[Instruction.scala 161:55]
    node _registerFile_io_RS2_T = bits(instructionMemory.io_rdData, 20, 16) @[Instruction.scala 162:55]
    io_Instr_word <= instructionMemory.io_rdData @[Instruction.scala 164:19]
    io_add_op <= decoder.io_add_op @[Instruction.scala 148:15]
    io_sub_op <= decoder.io_sub_op @[Instruction.scala 149:15]
    io_lw_op <= decoder.io_lw_op @[Instruction.scala 150:14]
    io_sw_op <= decoder.io_sw_op @[Instruction.scala 151:14]
    io_nop_op <= decoder.io_nop_op @[Instruction.scala 152:15]
    io_RS1_out <= registerFile.io_RS1_out @[Instruction.scala 171:16]
    io_RS2_out <= registerFile.io_RS2_out @[Instruction.scala 172:16]
    decoder.clock <= clock
    decoder.reset <= reset
    decoder.io_Instr_word <= instructionMemory.io_rdData @[Instruction.scala 163:27]
    registerFile.clock <= clock
    registerFile.reset <= reset
    registerFile.io_RS1 <= _registerFile_io_RS1_T @[Instruction.scala 161:25]
    registerFile.io_RS2 <= _registerFile_io_RS2_T @[Instruction.scala 162:25]
    registerFile.io_Reg_WB <= UInt<1>("h0") @[Instruction.scala 167:28]
    registerFile.io_WB_data <= UInt<32>("h0") @[Instruction.scala 168:29]
    instructionMemory.clock <= clock
    instructionMemory.reset <= reset
    instructionMemory.io_rdEna <= io_rdEna @[Instruction.scala 155:32]
    instructionMemory.io_wrEna <= io_wrEna @[Instruction.scala 156:32]
    instructionMemory.io_wrAddr <= io_wrAddr @[Instruction.scala 157:33]
    instructionMemory.io_wrData <= io_wrData @[Instruction.scala 158:33]
