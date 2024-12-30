//
//  OnBording.swift
//  zhr
//
//  Created by Huda Almadi on 30/12/2024.
//

import SwiftUI

struct OnBording: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var navigateToSignIn = false // إضافة حالة للتنقل إلى SignInScreen

    init() {
        // تغيير لون النقاط إلى اللون الموفي
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("PurpleDark")) // اللون الحالي
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color("PurpleLight")) // اللون للأخرى
    }

    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentPage) {
                    // الصفحة الأولى
                    OnboardingPageView(
                        image: "ZHR", // استبدل باسم الصورة
                        title: "Welcome to Zhr",
                        description: "A companion designed to support individuals with Alzheimer’s and their caregivers."
                    )
                    .tag(0)

                    // الصفحة الثانية
                    OnboardingPageView(
                        image: "ZhrWatch", // استبدل باسم الصورة
                        title: "Connect their Apple Watch for!",
                        description: """
                        Daily tracking
                        Reminders
                        Notifications
                        Communication
                        """
                    )
                    .tag(1)

                    // الصفحة الثالثة
                    VStack {
                        Spacer()

                        // محتوى الصفحة
                        OnboardingPageView(
                            image: "ZHR", // استبدل باسم الصورة
                            title: "Let's get started!",
                            description: "Let's get started on this journey toward peace of mind!"
                        )

                        // الزر
                        Spacer()

                        Button(action: {
                            hasSeenOnboarding = true
                            navigateToSignIn = true // تحديد التنقل إلى SignInScreen
                        }) {
                            Text("Next")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("PurpleDark"))
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                        }
                        .padding(.bottom, 46) // إضافة مسافة سفلية للزر
                    }
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .environment(\.layoutDirection, .leftToRight) // إجبار السوايب ليكون LTR

                // الانتقال إلى SignInScreen عند النقر على "Next"
                .background(
                    NavigationLink(destination: SignInScreen(), isActive: $navigateToSignIn) {
                        EmptyView()
                    }
                    .hidden()
                )
            }
        }
    }
}

struct OnboardingPageView: View {
    let image: String
    let title: String
    let description: String

    var body: some View {
        VStack {
            Spacer()

            // الصورة
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            // العنوان
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("PurpleDark"))
                .padding(.top, 20)

            // النص التوضيحي
            Text(description)
                .font(.body)
                .foregroundColor(Color("GrayDark"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()
        }
    }
}

struct OnBording_Previews: PreviewProvider {
    static var previews: some View {
        OnBording()
    }
}
