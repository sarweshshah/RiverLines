import codeanticode.syphon.*;
import java.util.List;
import org.openkinect.processing.*;

Kinect2 kinect2 = new Kinect2(this);
SyphonServer server = new SyphonServer(this, "RiverLines");

class KinectController {
  float kinMinThresh = 900;
  float kinMaxThresh = 970;
  PImage img;

  boolean isKinectViewerOn = false;

  KinectController() {
    kinect2.initDepth();
    kinect2.initDevice();

    img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  }

  void update() {
    img.loadPixels();

    // Get the raw depth as array of integers
    int[] depth = kinect2.getRawDepth();

    float sumX = 0;
    float sumY = 0;
    float totalPixels = 0;

    for (int x = 0; x < kinect2.depthWidth; x++) {
      for (int y = 0; y < kinect2.depthHeight; y++) {      
        int offset = x + y * kinect2.depthWidth;
        int d = depth[offset];

        if (d > kinMinThresh && d < kinMaxThresh) {
          img.pixels[offset] = color(255, 0, 150);
          sumX += x;
          sumY += y;
          totalPixels++;
        } else {
          img.pixels[offset] = color(51);
        }
      }
    }

    img.updatePixels();
    if (isKinectViewerOn) {
      pushMatrix();
      translate(-width/2, -height/2);
      image(img, 0, 0);
      popMatrix();
    }

    float avgX = sumX / totalPixels;
    float avgY = sumY / totalPixels;
    float mappedX = mouseX; 
    float mappedY = mouseY;

    if (totalPixels >= 900) {
      mappedX = map(avgX, 0, kinect2.depthWidth, -width/2, width/2);
      mappedY = map(avgY, 0, kinect2.depthHeight, -height/2, height/2);

      if (isKinectViewerOn) {
        pushMatrix();
        translate(-width/2, -height/2);
        fill(150, 0, 255);
        ellipse(avgX, avgY, 15, 15);
        popMatrix();
      }
      fill(150, 255, 255);
      ellipse(mappedX, mappedY, 15, 15);
    }
  }
}
