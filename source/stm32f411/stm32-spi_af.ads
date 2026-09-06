
with Interfaces;

package STM32.SPI_AF is

   subtype SPI_AF is Interfaces.Unsigned_32 range 5 .. 7;

   SPI_1_AF   : constant SPI_AF := 5;
   SPI_2_AF   : constant SPI_AF := 6;
   SPI_3_AF   : constant SPI_AF := 5;
   SPI_4_AF   : constant SPI_AF := 5;
   SPI_5_AF   : constant SPI_AF := 6;

end STM32.SPI_AF;
