import PhotosUI
import SwiftUI

struct PhotoPickerRow: View {
    private static let photoSize: CGFloat = 104
    private static let borderWidth: CGFloat = 1
    private static let removeButtonScale: CGFloat = 0.8

    let photos: [PickedPhoto]
    let checkingPhotosCount: Int
    let canAddPhotos: Bool
    let remainingSlots: Int
    let onPicked: ([Data]) -> Void
    let onRemove: (UUID) -> Void
    @State private var selection: [PhotosPickerItem] = []

    var body: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.m) {
                ForEach(photos) { photo in
                    thumbnail(photo)
                }
                ForEach(0..<checkingPhotosCount, id: \.self) { _ in
                    ProgressView()
                        .frame(width: Self.photoSize, height: Self.photoSize)
                        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.container))
                        .accessibilityLabel("checking_photo")
                }
                if canAddPhotos {
                    PhotosPicker(selection: $selection, maxSelectionCount: remainingSlots, matching: .images) {
                        VStack(spacing: Spacing.s) {
                            Image(systemName: "photo.badge.plus")
                                .font(.title2)
                            Text("add_photos")
                                .appStyle(.labelSmall)
                        }
                        .foregroundStyle(Palette.primary)
                        .frame(width: Self.photoSize, height: Self.photoSize)
                        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.container))
                        .overlay(RoundedRectangle(cornerRadius: CornerRadius.large).stroke(Palette.outlineVariant, lineWidth: Self.borderWidth))
                    }
                }
            }
            .padding(.horizontal, Spacing.screen)
        }
        .onChange(of: selection) { _, items in
            guard !items.isEmpty else {
                return
            }
            selection = []
            Task {
                var loaded: [Data] = []
                for item in items {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        loaded.append(data)
                    }
                }
                onPicked(loaded)
            }
        }
    }

    private func thumbnail(_ photo: PickedPhoto) -> some View {
        return ZStack(alignment: .topTrailing) {
            Group {
                if let image = UIImage(data: photo.data) {
                    Image(uiImage: image).resizable().scaledToFill()
                } else {
                    Palette.container
                }
            }
            .frame(width: Self.photoSize, height: Self.photoSize)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
            CircleIconButton(
                systemImage: "xmark",
                accessibilityLabel: "remove_photo",
                background: Palette.dimmed,
                foreground: Palette.white
            ) {
                onRemove(photo.id)
            }
            .scaleEffect(Self.removeButtonScale)
            .padding(Spacing.xs)
        }
    }
}
