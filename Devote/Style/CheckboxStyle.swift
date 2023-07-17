//
//  CheckboxStyle.swift
//  Devote
//
//  Created by Sergey Hrabrov on 17.07.2023.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    
                    if configuration.isOn {
                        playSound(sound: "sound-rise", type: "mp3")
                        feedback.notificationOccurred(.success)
                    } else {
                        playSound(sound: "sound-tap", type: "mp3")
                        feedback.notificationOccurred(.error)
                    }
                }
            
            configuration.label
        } // HStack
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholder", isOn: .constant(true))
            .toggleStyle(CheckboxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
