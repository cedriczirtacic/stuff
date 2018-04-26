package main

import (
	"fmt"
	noty "github.com/deckarep/gosx-notifier"
	"gocv.io/x/gocv"
	"image"
	"image/png"
	"log"
	"os"
	"time"
)

/* threshold before treating the presence as an attempt */
const threshold = 10

var err error

func alert() error {
	n := noty.NewNotification("Alert!")
	n.Title = "ATTENTION!!"
	n.Subtitle = "You are not authorized to access this computer!"
	n.Sound = noty.Glass
	err = n.Push()

	if err != nil {
		log.Printf("error: %s", err.Error())
		return err
	}
	return nil
}

func SaveFace(m *image.Image) error {
	timestamp := time.Now().UnixNano()
	filename := fmt.Sprintf("./%d.png", timestamp)

	fd, err := os.Create(filename)
	if err != nil {
		return err
	}

	err = png.Encode(fd, *m)

	return err
}

func CheckThreshold(tmp *int) {
	t := *tmp
	time.Sleep(3 * time.Second)
	if t == *tmp {
		*tmp = 0 //reset
	}
}

func main() {
	/* get camera */
	webcam, err := gocv.VideoCaptureDevice(0)
	if err != nil {
		log.Fatal(err.Error())
	}
	defer webcam.Close()

	/* main img (mat) interface */
	img := gocv.NewMat()
	defer img.Close()

	/* classifier is in charge of the object detection */
	classifier := gocv.NewCascadeClassifier()
	defer classifier.Close()

	loaded := classifier.Load("./src/gocv.io/x/gocv/data/haarcascade_frontalface_default.xml")
	if !loaded {
		log.Fatal("error: Error loading the classifier.")
	}

	tmp_threshold := 0
	for {
		webcam.Read(&img)
		if img.Empty() {
			continue
		}

		face := classifier.DetectMultiScale(img)
		if len(face) > 0 {
			/* face detected */
			if tmp_threshold < threshold {
				tmp_threshold++
				go CheckThreshold(&tmp_threshold)
			} else {
				alert()
				outimg, _ := img.ToImage()

				if err = SaveFace(&outimg); err != nil {
					log.Printf("error: %s", err.Error())
				}
				tmp_threshold = 0
			}
		}
	}
}
