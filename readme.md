# Project 1 - *fliCKr*

**fliCKr** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **~12** hours spent in total 

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies. 
- [x] Implement segmented control to switch between list view and grid view.  
- [x] Add a search bar.  
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.  //changes selection style.
- [x] Customize the navigation bar.   //Add icon for titleview , segment control to switch list/grid.

The following **additional** features are implemented:

- [x] Auto Layout
- [x] Animate - Search bar on Search Icon / Cancel.
- [X] Infinite Scroll - by paginating through API.
- [X] On Detail Screens - pan the details Animation (Up/Down) using spring velocity/dampening  and Fade.
- [x] Trailer from Youtube on Details Screen on Pan up. (Uses movieDB api to get id of youtube trailer for the movie).
- [x] Both Collection/Table views - same pull to refresh/infinite scroll , and data inputs.



## Video Walkthrough

Here's a walkthrough of implemented user stories:


[Dropbox Link for mov file](https://www.dropbox.com/s/7o0z28a4mod4fqo/flicker.mov?dl=0) 

<img src='https://github.com/eadencode/Flickr/blob/master/flickrgif.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).


## Notes

- Scroll View with auto layout had some problems 
- Few Auto Layout issues.
- Spent time on understanding right assets for right views (nav / tab / icon ) 50/75/30 .. @1x/@2x/

## Pods used and attributed to corresponding license within each Pod. 
- AFNetworking
- ICSPullToRefresh
- JGProgressHUD
- youtube-ios-player-helper


## License

    Copyright [2017] [Chaitanya Kannali]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
