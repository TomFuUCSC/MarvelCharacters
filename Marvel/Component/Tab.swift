// Author: Tom Fu
import SwiftUI

enum TabMode: CaseIterable {
    case comics
    case events

    var isComics: Bool {
        self == .comics
    }
}

struct Tab: View {
    @Binding var mode: TabMode
    let comicsCount: Int?
    let eventsCount: Int?

    @Namespace private var animation

    var body: some View {
        HStack(spacing: 10) {
            ForEach(TabMode.allCases, id: \.self) { tab in
                VStack {
                    tabIcon(tab: tab, mode: mode)
                    Text(getTitle(for: tab))
                        .font(.system(size: 12, weight: .bold))
                        .padding(.top, 5)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background {
                    if mode == tab {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.gray.opacity(0.3))
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                .foregroundColor(mode == tab ? .primary : .secondary)
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                        mode = tab
                    }
                }
            }
        }
    }

    private func getTitle(for tab: TabMode) -> String {
        if let count = tab.isComics ? comicsCount : eventsCount {
            return "\(count)"
        } else {
            return ""
        }
    }

    private func tabIcon(tab: TabMode, mode: TabMode) -> some View {
        var iconName = ""
        if tab == .comics {
            iconName = tab == mode ? "book.fill" : "book"
        } else {
            iconName = tab == mode ? "tv.fill" : "tv"
        }
        return Image(systemName: iconName)
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab(mode: .constant(.comics), comicsCount: 10, eventsCount: 10)
    }
}
