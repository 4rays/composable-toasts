import Foundation

public struct ToastConfig: Identifiable, Hashable, Sendable {
  public let id: UUID
  public let title: String
  public let subtitle: String?
  public let level: ToastLevel
  public let duration: Int
  public let buttonLabel: String?

  public init(
    id: UUID = .init(),
    title: String,
    subtitle: String? = nil,
    level: ToastLevel,
    duration: Int = 4,
    buttonLabel: String? = nil
  ) {
    self.id = id
    self.title = title
    self.subtitle = subtitle
    self.level = level
    self.duration = duration
    self.buttonLabel = buttonLabel
  }
}
