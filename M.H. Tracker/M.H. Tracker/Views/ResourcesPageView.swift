//
//  ResourcesPageView.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

import SwiftUI
import SafariServices

struct ResourcesPageView: View {
    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationView {
            List {
                Button("UMD Counseling Services") {
                    openURL(URL(string: "https://counseling.umd.edu/cs/immediatehelp")!)
                }
                Button("National Institute of Mental Health") {
                    openURL(URL(string: "https://www.nimh.nih.gov")!)
                }
                Button("Nutrition Services") {
                    openURL(URL(string: "http://www.health.umd.edu/nutritionservices")!)
                }
                Button("On Panic Attacks") {
                    openURL(URL(string: "https://ct.counseling.org/2018/07/when-panic-attacks/")!)
                }
                Button("On Depression") {
                    openURL(URL(string: "https://wp.me/p2BxKN-4V1")!)
                }
                Button("The Tangible Eddects of Invisible Illness") {
                    openURL(URL(string: "https://ct.counseling.org/2016/04/the-tangible-effects-of-invisible-illness/")!)
                }
                Button("Battling Against Burn-Out") {
                    openURL(URL(string: "https://ct.counseling.org/2018/03/the-battle-against-burnout/")!)
                }
                Button("Cultivating a Practice of Mindfulness") {
                    openURL(URL(string: "https://ct.counseling.org/2016/12/cultivating-practice-mindfulness/")!)
                }
               
            }
            .navigationTitle("Resources")
        }
    }
}


struct ResourcesPageView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesPageView()
    }
}
