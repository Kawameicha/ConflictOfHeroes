struct UnitRow: View {
    var unit: Unit

    var body: some View {
        HStack {
            UnitSymbolView(unit: unit)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading) {
                Text(unit.name)
                    .font(.headline)
                Text(unit.type.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(unit.army.description)
                .padding(6)
                .background(Capsule().fill(Color(unit.army.description)))
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}