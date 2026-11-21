const express = require('express');
const CustomList = require('../models/CustomList');
const asyncHandler = require('../utils/asyncHandler');
const { protect } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

router.use(protect);

router.get(
  '/',
  asyncHandler(async (req, res) => {
    const lists = await CustomList.find({ userId: req.user._id })
      .populate('places', 'name categoryId rating priceRange address images location')
      .sort({ updatedAt: -1 })
      .lean();
    res.json({ success: true, count: lists.length, lists });
  })
);

router.post(
  '/',
  asyncHandler(async (req, res) => {
    const { name, description, isPublic } = req.body;
    if (!name || !name.trim()) {
      throw new ApiError(400, 'List name is required.');
    }
    const list = await CustomList.create({
      userId: req.user._id,
      name: name.trim(),
      description: description || '',
      isPublic: Boolean(isPublic),
      places: [],
    });
    res.status(201).json({ success: true, list });
  })
);

router.post(
  '/:id/places',
  asyncHandler(async (req, res) => {
    const { placeId } = req.body;
    if (!placeId) throw new ApiError(400, 'placeId is required.');

    const list = await CustomList.findOne({ _id: req.params.id, userId: req.user._id });
    if (!list) throw new ApiError(404, 'List not found.');

    if (!list.places.includes(placeId)) {
      list.places.push(placeId);
      await list.save();
    }

    const updatedList = await CustomList.findById(list._id).populate(
      'places',
      'name categoryId rating priceRange address images location'
    );
    res.json({ success: true, list: updatedList });
  })
);

router.delete(
  '/:id/places/:placeId',
  asyncHandler(async (req, res) => {
    const list = await CustomList.findOne({ _id: req.params.id, userId: req.user._id });
    if (!list) throw new ApiError(404, 'List not found.');

    list.places = list.places.filter((p) => String(p) !== String(req.params.placeId));
    await list.save();

    const updatedList = await CustomList.findById(list._id).populate(
      'places',
      'name categoryId rating priceRange address images location'
    );
    res.json({ success: true, list: updatedList });
  })
);

router.delete(
  '/:id',
  asyncHandler(async (req, res) => {
    const list = await CustomList.findOneAndDelete({ _id: req.params.id, userId: req.user._id });
    if (!list) throw new ApiError(404, 'List not found.');
    res.json({ success: true, message: 'List deleted.' });
  })
);

module.exports = router;
