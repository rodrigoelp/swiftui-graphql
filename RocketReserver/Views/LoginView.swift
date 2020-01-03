//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var store: DataStore

    @State var email: String = ""

    var body: some View {
        VStack {
            Text("Provide an email")
            TextField("email", text: $email)
                .textContentType(UITextContentType.emailAddress)
                .autocapitalization(UITextAutocapitalizationType.none)
                .padding()
            
            Text(store.authToken)

            Button(action: { self.store.logIn(email: self.email) }, label: { Text("Start!") })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(email: "")
    }
}
