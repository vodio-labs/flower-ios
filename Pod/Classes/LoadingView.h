// LoadingView.h
// Copyright © 2015 Vodio Labs Ltd. (http://www.vod.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>


/**
 * 'LoadingView' class is a view which blocks user interaction, places a spinner in the middle of the screen and a light
 * shadow on all backgroud. This allows Flower (@see Flower) to get into blocking mode if the running 
 * process (@see FlowerProcess) requires blocking.
 *
 * Calling @see startLoading: will set this view to the top of the app main window subviews.
 * Calling @see stopLoading: will remove this view from the app main window subviews.
 *
 */

@interface LoadingView : UIView


/**
 Whether this view in in loading mode or not.
 */
@property (nonatomic) BOOL loading;


/**-----------------------------------------------------------------------------
 * @name Accessing a shared LoadingView instance.
 * -----------------------------------------------------------------------------
 *
 * @return The shared LoadingView instance, creating it if necessary.
 */
+(LoadingView*) instance;


/**-----------------------------------------------------------------------------
 * @name Starting blocking mode, showing loading spinner.
 * -----------------------------------------------------------------------------
 *
 * @param animated Whether to animate this view when added to the main app screen.
 */
-(void) startLoading:(BOOL)animated;


/**-----------------------------------------------------------------------------
 * @name Stopping blocking mode, removing loading spinner.
 * -----------------------------------------------------------------------------
 *
 * @param animated Whether to animate this view when removed from the main app screen.
 */
-(void) stopLoading:(BOOL)animated completion:(void(^)(void))completion;

@end