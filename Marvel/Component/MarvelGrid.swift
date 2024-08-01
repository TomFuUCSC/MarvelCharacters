// Author: Tom Fu
import SwiftUI

enum GridMode {
    case main, detail
}

struct MarvelGrid: View {
    @Environment(\.navigate) private var navigate

    @ObservedObject var model: GridModel

    @State private var hasFetched = false
    let titleShown: Bool
    let tappable: Bool
    let columns: [GridItem] = Array(
        repeating: .init(.flexible(), spacing: Constant.gridSpacing),
        count: 3
    )

    init(model: GridModel, titleShown: Bool = true, tappable: Bool = true) {
        self.model = model
        self.titleShown = titleShown
        self.tappable = tappable
        self.hasFetched = !tappable
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: Constant.gridSpacing) {
                ForEach(model.characters) { character in
                    GridCell(character: character, titleShown: titleShown)
                        .clipped()
                        .onAppear {
                            model.loadMoreIfCan(character)
                        }
                        .disabled(!tappable)
                        .onTapGesture {
                            navigate(.detail(character))
                        }
                }
            }
            Spacer(minLength: 40)
            if hasFetched, model.characters.isEmpty {
                NoDataView()
            }
        }
    }
}

struct CharactersGrid_Previews: PreviewProvider {
    static var previews: some View {
        MarvelGrid(model: GridModel(.characters, characters: Character.mock))
    }
}
