DIFFICULTY = {
  beginner: {
    w: 9,
    h: 9,
    mines: 10,
  },

  intermediate: {
    w: 16,
    h: 16,
    mines: 40,
  },

  expert: {
    w: 30,
    h: 16,
    mines: 99,
  },
}

FLAG_STATES = [nil, :flag, :question_mark]

# Offsets to find neighboring cells
OFFSETS = [-1, 0, 1].product([-1, 0, 1])
                    .reject { |ox, oy| ox == 0 && oy == 0 }
