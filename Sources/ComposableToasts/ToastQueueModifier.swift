import ComposableArchitecture
import SwiftUI

public struct ToastQueueViewModifier: ViewModifier {
  private var store: StoreOf<ToastQueue>

  public init(store: StoreOf<ToastQueue>) {
    self.store = store
  }

  public func body(content: Content) -> some View {
    content.overlay(
      ZStack {
        if let scoped = store.scope(
          state: \.currentToast,
          action: \.currentToast
        ) {
          ToastView(store: scoped)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .compositingGroup()
            .transition(
              AnyTransition.move(edge: .bottom)
                .combined(with: .opacity)
            )
        }
      }
        .animation(
          .spring(response: 0.4, dampingFraction: 0.7),
          value: store.currentToast
        )
    )
  }
}

extension View {
  public func toast(
    _ store: StoreOf<ToastQueue>
  ) -> some View {
    self.modifier(
      ToastQueueViewModifier(store: store)
    )
  }
}

#Preview {
  @Previewable @State var toggle = false
  VStack {
    Button("Toggle") {
      toggle.toggle()
    }
    .buttonStyle(.borderedProminent)

    ZStack {
      if toggle {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.blue)
          .frame(height: 100)
          .transition(
            AnyTransition.move(edge: .bottom)
              .combined(with: .opacity)
          )
      }
    }
    .padding()
    .frame(maxHeight: .infinity, alignment: .bottom)
  }

  .animation(
    .spring(response: 0.4, dampingFraction: 0.7),
    value: toggle
  )
}
