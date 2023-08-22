# Compression of Audio Signals using DCT


## Description
Audio compression has become one of the basic technologies of the multimedia age. In this project, I introduce a simple DCT transform-based coding system to decompose an audio signal. DCT is adopted because of its nice de-correlation and energy compaction properties. The resulting transform coefficients are quantized using non uniform scalar quantization. Then, the quantized values are represented using run length encoding (RLE) to prune the long 0s, followed by an improved shift coding algorithm.


## Methodology

The most prevalent feature of audio streams is redundant information between samples. Compression removes duplication and de-correlates data. Three modules make up a typical audio compression system. A suitable transformation is applied first. Second, transform coefficients are quantized to remove duplicate information. Quantified data should include minimal mistakes. Finally, quantized values are encoded using packed codes, modifying the coefficient format using suitable variable length encoding techniques.

### Functional Block Diagram<br>
![image](https://github.com/Shreyans27/Compression-of-audio-signals-using-DCT/assets/73150420/3b1b103b-6af5-4119-931e-8cebdca04cb3)


## Technical Details

### 1.) Discrete Cosine Transform<br>
![image](https://github.com/Shreyans27/Compression-of-audio-signals-using-DCT/assets/73150420/018397ae-7e85-463c-b0af-87950b80bab1)
<br>

Where f(0...N-1) is the discrete sequence of signal f; N is the number of f() elements; and C(0...N-1) is the cosine transform coefficient.

### 2.) Inverse Discrete Cosine Transform<br>
![image](https://github.com/Shreyans27/Compression-of-audio-signals-using-DCT/assets/73150420/cdde7753-4e12-4fd3-befb-47f83c034000)
<br>

The first transform coefficient C(0) is an indicator for the average value of the sample sequence; in the literature, this coefficient is called the DC coefficient of the signal.

### 3.) Thresholding / Quantization<br>

Thresholding is an important stage for data compression because it makes the approximate mapping of transform coefficient values to integer values have a finite length in binary representation. Any quantization method should be based on a principle that determines what data items to quantize and by how much. After the coefficients are received from different transforms, thresholding is done. Very few DCT coefficients represent 99% of the signal energy; hence, Thresholding is calculated and applied to the coefficients. Coefficients with values less than threshold values are removed.
