import chisel3._
import chisel3.util._

// 译码器
class Decoder extends Module {
    val io = IO(new Bundle {
        val Instr_word = Input(UInt(32.W))  // 输入信号

        // 输出信号
        val add_op = Output(Bool())
        val sub_op = Output(Bool())
        val lw_op = Output(Bool())
        val sw_op = Output(Bool())
        val nop_op = Output(Bool())
    })

    // opcode
    val AandS = "b000000".U(6.W)
    val ADD_OPCODE = "b100000".U(6.W)
    val SUB_OPCODE = "b100010".U(6.W)
    val LW_OPCODE = "b100011".U(6.W)
    val SW_OPCODE = "b101011".U(6.W)

    // 取出指令的 opcode 和 func 
    val opcode = io.Instr_word(31, 26)
    val func = io.Instr_word(5,0)

    // 指令默认是 nop
    io.add_op := false.B
    io.sub_op := false.B
    io.lw_op := false.B
    io.sw_op := false.B
    io.nop_op := true.B

    // 译码
    when (opcode === AandS) {
        when (func === ADD_OPCODE){
        io.add_op := true.B
        io.nop_op := false.B
        }.elsewhen (func === SUB_OPCODE){
        io.sub_op := true.B
        io.nop_op := false.B
        }
    }.elsewhen (opcode === LW_OPCODE) {
        io.lw_op := true.B
        io.nop_op := false.B
    }.elsewhen (opcode === SW_OPCODE) {
        io.sw_op := true.B
        io.nop_op := false.B
    }
}

// 寄存器文件
class RegisterFile extends Module {
    val io = IO(new Bundle {
        // 两读
        val RS1 = Input(UInt(5.W))
        val RS2 = Input(UInt(5.W))
        val RS1_out = Output(UInt(32.W))
        val RS2_out = Output(UInt(32.W))
        
        // 一写
        val Reg_WB = Input(Bool())
        val WB_data = Input(UInt(32.W))
    })

    val registers = RegInit(VecInit((0 until 32).map(i => i.U(32.W))))

    io.RS1_out := Mux(io.RS1 === 0.U, 0.U, registers(io.RS1))
    io.RS2_out := Mux(io.RS2 === 0.U, 0.U, registers(io.RS2))

    // 根据写信号选择要写入的寄存器
    when (io.Reg_WB) {
        registers(io.RS1) := Mux(io.RS1 === 0.U, 0.U, io.WB_data)
        registers(io.RS2) := Mux(io.RS2 === 0.U, 0.U, io.WB_data)
    }
}

// 指令
class Instruction extends Module {
    val io = IO(new Bundle {
        // 读
        val rdEna = Input(Bool())
        val rdData = Output(UInt(32.W))

        // 写
        val wrEna = Input(Bool())
        val wrAddr = Input(UInt(10.W))
        val wrData = Input(UInt(32.W))
    })

    val pcReg =  RegInit(0.U(32.W))

    val mem = SyncReadMem(128,UInt(8.W))

    // 写内存
    when (io.wrEna) {
        // 分 4 个单元写
        mem.write(io.wrAddr, io.wrData(7, 0))
        mem.write(io.wrAddr + 1.U, io.wrData(15, 8))
        mem.write(io.wrAddr + 2.U, io.wrData(23, 16))
        mem.write(io.wrAddr + 3.U, io.wrData(31, 24))
    }

    // 读内存
    when (io.rdEna) {
        // 分 4 个单元读
        val rdData0 = mem.read(pcReg)
        val rdData1 = mem.read(pcReg+1.U)
        val rdData2 = mem.read(pcReg+2.U)
        val rdData3 = mem.read(pcReg+3.U)
        io.rdData := rdData3 ## rdData2 ## rdData1 ## rdData0  // ## 表连接

        pcReg := pcReg + 4.U
    }.otherwise{
       io.rdData := 0.U
    }
}

// 综合
class Combination extends Module {
    val io = IO(new Bundle {
        // Decoder
        val Instr_word = Output(UInt(32.W))
        val add_op = Output(Bool())
        val sub_op = Output(Bool())
        val lw_op = Output(Bool())
        val sw_op = Output(Bool())
        val nop_op = Output(Bool())

        // RegisterFile
        val RS1_out = Output(UInt(32.W))
        val RS2_out = Output(UInt(32.W))

        // Instruction
        val rdEna = Input(Bool())
        val wrAddr = Input(UInt(10.W))
        val wrData = Input(UInt(32.W))
        val wrEna = Input(Bool())
    })

    // 实例化
    val decoder = Module(new Decoder)
    val registerFile = Module(new RegisterFile)
    val instructionMemory = Module(new Instruction)
  
    // 连接指令信号
    io.add_op := decoder.io.add_op
    io.sub_op := decoder.io.sub_op
    io.lw_op := decoder.io.lw_op
    io.sw_op := decoder.io.sw_op
    io.nop_op := decoder.io.nop_op

    // 连接控制信号
    instructionMemory.io.rdEna := io.rdEna
    instructionMemory.io.wrEna := io.wrEna
    instructionMemory.io.wrAddr := io.wrAddr
    instructionMemory.io.wrData := io.wrData

    // 连接输入数据
    registerFile.io.RS1 := instructionMemory.io.rdData(25,21)
    registerFile.io.RS2 := instructionMemory.io.rdData(20, 16)
    decoder.io.Instr_word := instructionMemory.io.rdData
    io.Instr_word := instructionMemory.io.rdData

    // 初始化寄存器文件的控制信号
    registerFile.io.Reg_WB := false.B
    registerFile.io.WB_data := 0.U

    // 连接模块输出信号
    io.RS1_out := registerFile.io.RS1_out
    io.RS2_out := registerFile.io.RS2_out
}

object Register extends App {
  println("Success!")
}
