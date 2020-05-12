Tilemap = Class{}

function Tilemap:init(col, row)
  self.col = col
  self.row = row

  self.x = 0
  self.y = 0

  self.tilewidth = 64
  self.tileheight = 64

  for i = 1, row do
    local t = {}
    for j = 1, col do
      table.insert(t, nil)
    end
    table.insert(self, t)
  end

  table.insert(entities, self)
  
end

function Tilemap:update(dt)

end

function Tilemap:render()
  for i = 1, self.row do
    for j = 1, self.col do
      if self[i][j] then
        self[i][j]:render()
      end
    end
  end
end
