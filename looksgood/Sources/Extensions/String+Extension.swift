import UIKit

final class Strings {
    static let hello = "Hello"
    static let whoAreYou = "Who are you?"
    static let restaurantOwner = "Restaurant Owner"
    static let user = "User"
    static let go = "Go"
    static let login = "Login"
    static let letsGo = "Lets go!"
    static let createAccount = "Create account"
    static let forgotPassword = "Forgot password?"
    static let email = "Email"
    static let password = "Password"
    static let username = "Username"
    static let profile = "Profile"
    static let logOut = "Logout"
    static let areYouSure = "Are you sure?"
    static let accountSettings = "Account settings"
    static let deleteAccount = "Delete account"
    static let deleteAccountConfirmation = "Are you sure? Your account will be gone forever."
    static let startAddingRestaurant = "Start adding your restaurant"
    static let done = "Done"
    static let or = "or"
    static let next = "Next"
    static let categoryInfo = "This will appear as main place category associated with your place. You can change it later in the settings."
    static let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    static let addImages = "Add images of your place."
    static let cancel = "Cancel"
    static let upload = "Upload"
    static let update = "Update"
    static let phoneNumber = "Phone number"
    static let website = "Website"
    static let price = "Price"
    static let name = "Name"
    static let descriptionOptional = "Description (optional)"
    static let addImage = "Add Image"
    static let unableToPreviewPhoto = "Unable to preview photo"
    static let selectCategory = "Select category"
    static let subCategory = "Sub category"
    static let delete = "Delete"
    static let navigate = "Navigate"
    static let call = "Call"
    static let startAddingPlace = "Start adding place"
    static let deleteItem = "Delete item?"
    static let thisMenuItemWillBeDeletedForever = "This menu item will be deleted forever."
    static let addImageForThisItem = "Add image for this item."
    static let photoAdded = "Photo added"
    static let somethingWentWrong = "Something went wrong"
    static let map = "Map"
    static let panel = "Panel"
    static let list = "List"
}

extension String {
    var isNotEmptyString: Bool {
        if self == "" {
            return false
        }
        return true
    }

    var isEmptyString: Bool {
        if self == "" {
            return true
        }
        return false
    }
}
