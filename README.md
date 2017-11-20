# Ostmodern

So, I spent part of the weekend getting the Ostmodern test app in better shape than it was when I first saw it. The process went something like this:

1. Create the git repository on github, and clone it locally.
2. Copy the Xcode project into the mostly empty local clone.
3. Commit.
4. Fix build errors.
5. Once it would build, fix logic errors. It was obvious something was wrong, as it just displayed a blank screen!
6. Once it built, and more or less behaved, I moved on to adding features, such as the details view.
7. Test, and fix issues as they arose.

I hope the detail view is what was asked for. It displays all the data associated with the item, rather than just the synopsis displayed in the set view. On startup the app will show the home sets. Tapping on an item in the table view will push a detail view with more information onto the navigation stack. The user can favourite items from the main sets view, and the favourites are persisted across sessions.

One challenge was having to deal with quite a bit of unfamiliar code. Not just Ostmodern itself, but also the third party projects, such as Alamofire, Realm and SwiftyJSON. It was worth gaining some level of understanding, as existing code certainly saved a lot of effort going from JSON to an object graph for example.

Obvioulsy the git log will give you an idea of how I set about the problem. There are a couple of times where code was written quickly in a convenient location, and then moved somewhere more architecturally desireable. I think this is fair enough when you want to try and understand how an unfamiliar class or method works. The realm code being used in a view controller, before being encapsulated in the Database class being a case in point.

I noticed on the set view, there are items that have a title, and very little else. i.e. no description or images associated with them. I wasn't entirely sure what these represented. I ended up just displaying them using what they had. In the real world, I would have liked to ask for some clarification.

Finally, there's obviously a bit of a disconnect between making something production ready, and spending a suggested few hours on it. I hope I achieved the right balance.

To build:
git clone https://github.com/jameswrw/Ostmodern.git
pod update
open ostest.xcworkspace, and build the ostest target.

The project builds with one warning. Usually I like to get rid of them all, but in this case it's just a nag to use Swift 4, but the specification is clear that this is a Swift 3 project, so I wasn't going to change this. Although Swift 4's JSONDecoder might put SwiftyJSON out of work... (There may be a second warning. Again it's a nag. This time to upgrade the Pods project to the latest settings.)

James

