require 'gilded_rose'
require 'item'
require 'spec_helper'

describe GildedRose do

  describe '#update_quality' do

   it 'does not change the name' do
     items = [Item.new(name="foo", sell_in=1, quality=0)]
     GildedRose.new(items).update_quality()
     expect(items[0].name).to eq "foo"
   end

    it 'lowers sell in value by 1 at the end of the day' do
      items = [Item.new(name="foo", sell_in=1, quality=0)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 0
    end

    it 'lowers quality value by 1 at the end of the day' do
      items = [Item.new(name="foo", sell_in=1, quality=1)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end

    it 'sell in value can be negative' do
      items = [Item.new(name="foo", sell_in=0, quality=0)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq -1

    end

    it 'quality value is never negative' do
      items = [Item.new(name="foo", sell_in=1, quality=0)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end

    it 'quality value is never more than 50' do
      items = [Item.new(name="foo", sell_in=1, quality=50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to be <=50
    end

    context 'when sell in date is passed' do
      it 'lowers quality value by 2 at the end of the day' do
      items = [Item.new(name="foo", sell_in=0, quality=50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to be <=48
    end
  end

    context 'when item is Aged Brie' do
      it 'increases in quality by 1 if sell_in >=0' do
        items = [Item.new(name="Aged Brie", sell_in=1, quality=1)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end

      it 'increases in quality by 2 if sell_in <=0' do
        items = [Item.new(name="Aged Brie", sell_in=-1, quality=1)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 3
      end

      it 'max quality is 50' do
        items = [Item.new(name="Aged Brie", sell_in=-1, quality=50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end


      context 'when item is Sulfuras' do
        it 'never has to be sold' do
          items = [Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=1, quality=1)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 1
        end

        it 'does not change quality' do
          items = [Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=1, quality=1)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 1
        end
      end
    end

    context 'when item Backstage passes to a TAFKAL80ETC concert' do
      it 'increases in quality as its sellin value approaches by 2 when > 10 days' do
        items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=11, quality=2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 3
    end

    it 'quality does not exceed 50' do
      items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=6, quality=50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
  end


      it 'increases in quality as its sellin value approaches by 2 when < 10 days' do
        items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=6, quality=2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 4
    end

    it 'increases in quality as its sellin value approaches by 3 when < 5 days' do
      items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=4, quality=2)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 5
    end

    it 'quality drops to 0 after the concert' do
      items = [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=2)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end
    end

    context 'conjured' do
      it 'conjured degrade in quality twice as fast as normal items' do
        items = [Item.new(name="Conjured Mana Cake", sell_in=1, quality=2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end
    end
end
end
