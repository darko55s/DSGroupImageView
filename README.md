# DSGroupImageView
Swift library for making compositions of multiple images

<img src="one.png" width="300" height="300" />
<img src="two.png" width="300" height="300" />
<img src="three.png" width="300" height="300" />
<img src="four.png" width="300" height="300" />

## Manual install

Simply drag and drop the **DSGroupImageView.swift** file inside your project in xCode and you are good to go. The library is writen in Swift so if you want to use it in Objective-C project you would need to have the "ProjectName-Swift.h" file autogenerated by xCode for you

## Usage

After adding the library to your poject open up your viewController and inicialize your array of image URL's that you want to use. Add DSGroupImageView in your storyboard or inicialize via code. Currently supporting 1 to 4 images maximum.

```Swift
  var images = ["https://randomuser.me/api/portraits/women/44.jpg","https://randomuser.me/api/portraits/women/42.jpg",     "https://randomuser.me/api/portraits/men/44.jpg"]

  groupImageView.dataSource = self 
  groupImageView.reloadViews()
```
Implement the DataSource methods like below:

```Swift
   func numberOfImagesInView() -> Int {
      return images.count
   }
   
   func imageAt(index: Int) -> String {
      return images[index]
   }
```
   
## Dependences 
[Kingfisher](https://github.com/onevcat/Kingfisher)
