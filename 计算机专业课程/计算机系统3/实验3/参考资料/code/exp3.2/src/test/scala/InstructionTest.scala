import chiseltest._
import chisel3._
import org.scalatest.flatspec.AnyFlatSpec

class InstructionTest extends AnyFlatSpec with ChiselScalatestTester {
    behavior of "Combination"
    it should "pass" in {
        test(new Combination).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
            val ADD = "b00000000010000110000100000100000".U(32.W)  // add R1, R2, R3 的十六进制为 00430820
            val SUB = "b00000000101001100000000000100010".U(32.W)  // sub R0, R5, R6 的十六进制为 00A60022
            val LW  = "b10001100101000100000000000110010".U(32.W)  // lw R5, 100(R2) 的十六进制为 8CA20032
            val SW  = "b10101100101000100000000000110100".U(32.W)  // sw R5, 104(R2) 的十六进制为 ACA20034
            val JAL = "b00001100001000100000000000110010".U(32.W)  // jal 100        的十六进制为 0C220032

            c.clock.setTimeout(0)  // 初始化时钟

            // ADD 指令
            c.io.wrEna.poke(true)
            c.io.wrAddr.poke(0.U)
            c.io.wrData.poke(ADD)
            c.clock.step(1)
            
            // SUB 指令
            c.io.wrEna.poke(true)
            c.io.wrAddr.poke(4.U)
            c.io.wrData.poke(SUB)
            c.clock.step(1)

            // LW 指令
            c.io.wrEna.poke(true)
            c.io.wrAddr.poke(8.U)
            c.io.wrData.poke(LW)
            c.clock.step(1)

            // SW 指令
            c.io.wrEna.poke(true)
            c.io.wrAddr.poke(12.U)
            c.io.wrData.poke(SW)
            c.clock.step(1)

            // JAL 指令
            c.io.wrEna.poke(true)
            c.io.wrAddr.poke(16.U)
            c.io.wrData.poke(JAL)
            c.clock.step(1)

            // 结束
            c.io.wrEna.poke(false)
            c.io.rdEna.poke(true)
            c.clock.step(10)
        }
    }
}
