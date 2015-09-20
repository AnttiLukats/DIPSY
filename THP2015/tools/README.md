Introduction
============

Tools for the DIPSY, a sub-5 USD FPGA board.
See the homepage at https://hackaday.io/project/6592-dipsy .

Included are:
* dipsy-configure: Download configuration over SPI to the FPGA board.


Raspberry PI
============
Steps:
<ol>
<li>
Either remove "spi-bcm2708" from the blacklist in /etc/modprobe.d/raspi-blacklist.conf or (kernel 3.18 or newer): add dtparam=spi=on to /boot/config/txt
</li>
<li>
Reboot or modprobe spi-bcm2708
</li>
</ol>

Source: https://github.com/piface/pifacecommon/blob/master/docs/installation.rst

Pinout on P1:<table>
<tr>
	<th>P1</th><th>DIPSY</th>
</tr>
<tr>
	<td>25</td><td>GND</td>
</tr>
<tr>
	<td>23</td><td>SCLK</td>
</tr>
<tr>
	<td>22</td><td>RESET</td>
</tr>
<tr>
	<td>21</td><td>MISO</td>
</tr>
<tr>
	<td>20</td><td>GND</td>
</tr>
<tr>
	<td>19</td><td>MOSI</td>
</tr>
<tr>
	<td>18</td><td>CDONE</td>
</tr>
<tr>
	<td>17</td><td>+3.3V</td>
</tr>
<tr>
	<td>16</td><td>SS</td>
</tr>
</table>

Intel Edison Arduino breakout
=============================
Update to the latest version as of 2015-09-05.

Pinout:<table>
<tr>
	<th>J1B1</th><th>DIPSY</th>
</tr>
<tr>
	 <td>8</td><td>RESET</td>
</tr>
<tr>
	 <td>9</td><td>DONE</td>
</tr>
<tr>
	<td>10</td><td>SS</td>
</tr>
<tr>
	<td>11</td><td>MOSI</td>
</tr>
<tr>
	<td>12</td><td>MISO</td>
</tr>
<tr>
	<td>13</td><td>SCK</td>
</tr>
</table>

Beaglebone
==========
Tested on revision A3, with Debian (BeagleBone, BeagleBone Black - 4GB SD) 2015-03-01.


Pinout on P9:<table>
<tr>
	<th>P9</th><th>DIPSY</th>
</tr>
<tr>
	<td>1,2</td> = <td>GND</td>
</tr>
<tr>
	<td>3,4</td> = <td>+3.3V</td>
</tr>
</table>

Pinout on P8:<table>
<tr>
	<th>P8</th><th>DIPSY</th>
</tr>
<tr>
	 <td>8</td><td>RESET</td>
</tr>
<tr>
	<td>10</td><td>SS</td>
</tr>
<tr>
	<td>12</td><td>DONE</td>
</tr>
<tr>
	<td>14</td><td>MOSI</td>
</tr>
<tr>
	<td>16</td><td>SCK</td>
</tr>
</table>
