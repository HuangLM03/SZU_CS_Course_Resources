import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class RegisterFileTest extends AnyFlatSpec with ChiselScalatestTester {
    behavior of "RegisterFile Module"

    it should "observe the effect on registers" in {
        test (new RegisterFile).withAnnotations(Seq(WriteVcdAnnotation)) { c =>
          // 设置输入信号
          c.io.RS1.poke(5.U) // RS1 = 5
          c.io.RS2.poke(8.U) // RS2 = 8
          c.io.WB_data.poke(0x1234.U) // WB_data = 0x1234

          // 时钟向前一步, 写入
          c.io.Reg_WB.poke(true) // 写使能
          c.clock.step(1)
      }
    }
}