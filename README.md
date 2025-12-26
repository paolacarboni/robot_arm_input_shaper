Reducing undesired vibrations is essential for the effective control of robotic manipulators.

This project implements the **Input Shaping Technique** for vibration reduction, as proposed by **Singer and Seering**. The method suppresses residual vibrations by reshaping the reference command, at the cost of an increased execution time.

A **one-link flexible arm** is considered, accounting for both **linear and nonlinear** vibration effects.

Case of linear vibrations:
<table align="center">
  <tr>
    <td align="center">
      <img src="regulation_no_shaper.gif" width="350" /><br/>
      <sub> Regulation task, baseline </sub>
    </td>
    <td align="center">
      <img src="regulation_shaper.gif" width="350" /><br/>
      <sub>Regulation task with input shaping </sub>
    </td>
  </tr>
</table>

<p align="center">
<img src="linear_response_P_controller.png" width="50%" alt="System diagram" />
</p>

Case of nonlinear vibrations: 

<table align="center">
  <tr>
    <td align="center">
      <img src="video_no_shaper_nl.gif" width="350" /><br/>
      <sub> Regulation task, baseline </sub>
    </td>
    <td align="center">
      <img src="video_shaper_nl.gif" width="350" /><br/>
      <sub>Regulation task with input shaping </sub>
    </td>
  </tr>
</table>


<table align="center">
  <tr>
    <td align="center">
      <img src="nonlinear_response_P_controller.png" width="350" /><br/>
    </td>
    <td align="center">
      <img src="nonlinear_response_PD_controller.png" width="350" /><br/>
    </td>
  </tr>
</table>
