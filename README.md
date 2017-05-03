# Recipe Manager

Recipe Manager is an application designed to create an easy way to store recipes with images to support the instruction set.  The app is designed to be a recipe repository however you can enter an Edit mode on any recipe so that you can alter and add to recipes.  

## Authors / Contact

[Chris Hight](mailto:chris.hight@wsu.edu)

SID 11483028

## Description

User will be able to document and keep their own recipes with not only text but images as well.  This recipe app will allow users a good amount of control over their recipe and provides a clean and visually appealing format way to read recipes.

   * Layout will stay consistent between landscape and portrait modes. Setup is a master detail app.
   
   * Layout will work on multiple devices and stretches to fit any iPhone or iPad model.
   
   * The Recipe will not allow for editing so that recipe is not mistakenly changed. You must enter edit mode to change recipe.
   
   * Menu allows for the selection of recipes or you may add a new recipe in the top right hand corner.
   
   * Edit button on menu, ingredients list will help in removing steps.  Simple swipe to the left will also bring up delete option on proper lists.
   
   * When adding images it will request access of the camera, if no camera exists it will request access to user's photos.
   
   * Ingredients must have a name, quantity and measurements are optional values.

   * Images are optional in the instructions section.
   
   * App comes with two recipes, "Green Eggs and Ham" and a drink recipe for "Jameson and Ginger"
      
   * Data persistence exists and will save recipes when shutdown and reopened. 
   
   * Images are saved in an NSCache while being used. They are also saved to the data set so that they can be accessed again later with a proper URL key
   
   * When adding a recipe it will ask for the type of recipe in a scroll wheel.  This is setup for further functionality in future updates.
   
## Future Improvements and Bug Fixes

   * A new main menu is being worked on.  It will have categories represented in a table view and within the category cell will be icons with images showing the recipes. 
   
   * Edit option on Instructions has an issue deleting instructions with images, it does work when images are not present.
  
  
   * Core Data and connection to iCloud to be implemented.
   
   * When accessing camera you will also be able to choose to access previous pictures taken in image library.
   
   * Cleaner and more efficient code, a lot of learning took place while writing this, I am sure I can make it cleaner by a long shot.
   
   * Implement order changing in instructions and ingredients. Was having an error throw when doing it before. Need to bug squash.

## How to build and run

This project must be ran using Xcode or an iOS device of 10.3 or later.  After cloning the project file you will find a folder and inside will be a file `Recipe Manager.xcodeproj`.  Double click this file to open the project into Xcode.  

## License
	
This is an original idea developed by Chris Hight.  The images developed for this app were also developed by Chris Hight using Adobe Illustrator.  Additional Images not of original development are listed below.

Instructions Tab Bar Icon - https://www.svmicrowave.com/sites/default/files/documents/images/CA_Instructions_Icon.png

Image Tab Bar Icon - https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-image-128.png

### Acknowledgements 

Thanks to my wife for having the patience to test this app for me on both the iPad Pro and iPhone 7 Plus.