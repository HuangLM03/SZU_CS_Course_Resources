import chisel3._
import chisel3.util._

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