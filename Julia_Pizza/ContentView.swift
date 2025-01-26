//
//  ContentView.swift
//  Julia_Pizza
//
//  Created by Julia Prats on 2024-02-02.
//

import SwiftUI

struct ContentView: View {
        @State private var pizzaType = 1 // non-veg
        @State private var pizzaSize = 1 // medium size
        @State private var quantity = 1
        @State private var name = ""
        @State private var phoneNumber = ""
        @State private var couponCode = ""
        
        let pizzaSizes = ["Small", "Medium", "Large", "Extra Large"]
        let pizzaOptions = ["Vegetarian", "Non-vegetarian"]
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Order details")) {
                        Picker("Pizza type", selection: $pizzaType) {
                            ForEach(0 ..< 2) {
                                Text(self.pizzaOptions[$0])
                            }
                        }
                        Picker("Pizza size", selection: $pizzaSize) {
                            ForEach(0 ..< 4) {
                                Text(self.pizzaSizes[$0])
                            }
                        }
                        Stepper(value: $quantity, in: 1...5) {
                            Text("Quantity: \(quantity)")
                        }
                        TextField("Name", text: $name)
                            .keyboardType(.default)
                        TextField("Phone number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                        TextField("Coupon code", text: $couponCode)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    Section {
                        Button{
                            placeOrder()
                        }label: {
                            Text("PLACE ORDER")
                                .foregroundColor(Color("ButtonText"))
                                .fontWeight(.bold)
                        }
                    }
                }
                .navigationBarTitle("Pizza Order App")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                setDailySpecial()
                            } label: {
                                Text("DAILY SPECIAL")
                            }

                            Button {
                                resetForm()
                            } label: {
                                Text("RESET")
                            }
                        } label: {
                            Image(systemName: "gear.circle.fill")
                                .foregroundColor(Color("StuffColor"))
                                
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Order receipt"), message: Text(receipt), dismissButton: .default(Text("OK")))
                }
            }
        }
        

        @State private var showingAlert = false
        @State private var receipt = ""
        
        // offerspecial values
        func setDailySpecial() {
            pizzaSize = 2
            quantity = 2
            pizzaType = 1
            couponCode = "OFFERSPECIAL"
        }
        
        // reset form
        func resetForm() {
            pizzaType = 1
            pizzaSize = 1
            quantity = 1
            name = ""
            phoneNumber = ""
            couponCode = ""
        }
        
        func placeOrder() {
            guard !name.isEmpty, !phoneNumber.isEmpty else {
                showingAlert = true
                receipt = "ERROR: Name and phone number are mandatory fields!"
                return
            }

            let isValidCoupon = couponCode.isEmpty || couponCode.hasPrefix("OFFER")

            if !isValidCoupon {
                showingAlert = true
                receipt = "ERROR: Invalid coupon code."
                return
            }

            var totalPrice: Double
            
            let basePrices: [[Double]] = [
                [5.99, 6.99],    // small size
                [7.99, 8.99],    // medium size
                [10.99, 12.99],  // large size
                [13.99, 15.00]   // extra large size
            ]
            let taxRate: Double = 0.13
            
            let basePrice = basePrices[pizzaSize][pizzaType]
            let discountedPrice = couponCode.hasPrefix("OFFER") ? basePrice * 0.8 : basePrice
            totalPrice = discountedPrice * Double(quantity) * (1 + taxRate)
            
            // receipt
            receipt = """
            Pizza Type: \(pizzaOptions[pizzaType])
            Pizza Size: \(pizzaSizes[pizzaSize])
            Quantity: \(quantity)
            Name: \(name)
            Phone Number: \(phoneNumber)
            Coupon Code: \(couponCode)
            
            Total Price: $\(String(format: "%.2f", totalPrice))
            """
            
            // alert
            showingAlert = true
        }
    }

#Preview {
    ContentView()
}
