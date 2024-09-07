import ComposableArchitecture
import SwiftUI

@Reducer
public struct ToastFeature {
  @ObservableState
  public struct State: Equatable, Sendable {
    public var config: ToastConfig

    public init(config: ToastConfig) {
      self.config = config
    }
  }

  public enum Action: Equatable, Sendable {
    case buttonTapped
    case toastTapped
  }
}

extension ToastConfig {
  var iconName: String {
    switch level {
    case .info: "lightbulb"
    case .warning: "exclamationmark.2"
    case .error: "xmark"
    case .success: "checkmark"
    }
  }

  var iconColor: Color {
    switch level {
    case .info: .orange
    case .warning: .brown
    case .error: .red
    case .success: .green
    }
  }
}

public struct ToastView: View {
  private let store: StoreOf<ToastFeature>

  public init(store: StoreOf<ToastFeature>) {
    self.store = store
  }

  public var body: some View {
    Button {
      store.send(.toastTapped)
    } label: {
      HStack(spacing: 8) {
        Image(systemName: store.config.iconName)
          .font(Font.body.bold())
          .foregroundStyle(store.config.iconColor)
          .padding()
          .background(
            Circle()
              .stroke(Color.primary.opacity(0.1), lineWidth: 2)
              .frame(width: 36, height: 36)
          )

        Group {
          if let subtitle = store.config.subtitle {
            Text(.init(store.config.title))
              .fontWeight(.semibold)
            + Text(" ")
            + Text(.init(subtitle))
          } else {
            Text(.init(store.config.title))
              .fontWeight(.semibold)
          }
        }
        .lineLimit(2)
        .multilineTextAlignment(.leading)

        Spacer()

        if let buttonLabel = store.config.buttonLabel {
          Button(buttonLabel) {
            store.send(.buttonTapped)
          }
        }
      }
      .font(.callout)
      .foregroundColor(.primary)
      .padding(8)
      .frame(maxWidth: 400)
      .background(
        .thickMaterial,
        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
      )
      .frame(maxWidth: .infinity, alignment: .center)
    }
  }
}

extension ToastView {
  static func data(_ data: ToastConfig) -> Self {
    .init(
      store: Store(
        initialState: .init(config: data)
      ) {
        ToastFeature()
      }
    )
  }
}

#Preview{
  VStack {
    ToastView.data(
      .init(
        title: "Game added!",
        subtitle: "It went well!",
        level: .success
      )
    )

    ToastView.data(
      .init(
        title: "Watch out!",
        subtitle:
          "So this toast right here rocks and you need to remember that. However the rest is not going to be visible.",
        level: .warning
      )
    )

    ToastView.data(
      .init(
        title: "An Error Occured",
        subtitle: "So this toast right here rocks but meh.",
        level: .error
      )
    )

    ToastView.data(
      .init(
        title: "This is some info",
        subtitle: "So this toast right here rocks and you need to remember that.",
        level: .info
      )
    )

    ToastView.data(
      .init(
        title: "Some error has happened.",
        level: .error
      )
    )
  }
  .padding()
  .containerRelativeFrame(.vertical)
  .background(
    LinearGradient(
      gradient: Gradient(colors: [.blue, .purple]),
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ),
    ignoresSafeAreaEdges: .all
  )
}
