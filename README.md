# WooliesX
WooliesX Tech test

 Pods used In this project: 
  pod 'SnapKit'
  pod 'RxCocoa'
  pod 'Alamofire'
  pod 'RxAlamofire'
  pod 'RxSwift'
  pod 'Kingfisher'

SnapKit used for in code lay outing. 
RxCocoa and RxSwift for reactive swift.
Alamofire and RxAlamofire for networking
Kingfisher for asynchronously downloading images. 

The Structure is based on MVVM. Api layer is completely separated from the Model and ViewModels. This makes writing Unit test easier. 

Currently the pull to refresh fetches again from the api, so we ignore the sorting on pull to refresh. 

On error we simply show the error description on an AlertController. 

The sorting is based on max life span. assuming the last number in the lifeSpan string is the maximum dog age.
