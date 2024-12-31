import SwiftUI
import AuthenticationServices

struct SignInScreen: View {
    @StateObject private var viewModel = SignInViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Image("ZHR")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Spacer().frame(height: 300)

                SignInWithAppleButton(
                    onRequest: viewModel.handleRequest,
                    onCompletion: { result in
                        viewModel.handleCompletion(result)
                        if case .success = result {
                            viewModel.isSignedIn = true
                            // Set UserDefaults to mark splash screen as shown
                            UserDefaults.standard.set(true, forKey: "hasShownSplashScreen")
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(width: 331, height: 59)
                .cornerRadius(16)
                .shadow(radius: 4)
                .accessibility(label: Text("Sign in with Apple"))

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .padding(.top, 100)
            .navigationDestination(isPresented: $viewModel.isSignedIn) {
                MainTabView() // Navigate to MainTabView when signed in
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SignInScreen()
}
