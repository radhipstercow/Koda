//
//  Copyright © 2017 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import FirebaseAuth
import SquarePointOfSaleSDK

/// You can find your application ID in the [application dashboard](https://connect.squareup.com/apps)
let SquareApplicationId = "sq0idp-Ec8zxtG-_BNYS4Cl2qDKxg"

/// This should be the same Callback URL Scheme registered in the [Application Dashboard](https://connect.squareup.com/apps)
let CallbackURLScheme = "koda://callback"

// In order to accept credit cards, the account logged in to Square Point of Sale must be activated. Visit squareup.com/activate.
// Once the account has been activated you can add the .card tender type below.
let TenderTypes: SCCAPIRequestTenderTypes = [.cash, .card]

// These constants are used to configure the Select Drink screen. See SelectDrinkViewController
let LocationName = "The Coffee Shop"
let LocationBackgroundImage = #imageLiteral(resourceName: "background")
let LocationLogoImage = #imageLiteral(resourceName: "logo")

let CurrencyCode = "USD"
